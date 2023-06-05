locals {
  telemetry_tags = {
    TELEMETRY_TAG_KEY = "TELEMETRY_TAG_VALUES"
  }
  tags = merge(var.tags, local.telemetry_tags)
}

data "azurerm_subnet" "db_subnet" {
  name                 = var.db_subnet_name
  resource_group_name  = var.xyz_vnet_name
  virtual_network_name = var.xyz_net_resource_group_name
}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group
}

data "azurerm_key_vault_key" "encryption_key" {
  name                = var.encryption_key_name
  key_vault_id        = data.azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "key_vault_password" {
  count = var.create_server && var.create_mode == "Default" ? 1 : 0
  name         = ("Postgres-Server-Password-${random_string.random_string[0].result}")
  value        = random_password.random_password[0].result
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

resource "random_string" "random_string" {
  count = var.create_server && var.create_mode == "Default" ? 1 : 0
  length = 12
  upper = true
  lower = true
  numeric = false
  special = false
}

resource "random_password" "random_password" {
  count = var.create_server && var.create_mode == "Default" ? 1 : 0
  length = 32
  special = false
  min_lower = 1
  min_upper = 1
  min_numeric = 1
}

resource "azurerm_postgresql_server" "postgres_server" {

  count = var.create_server && var.create_mode == "Default" ? 1 : 0

  name                    = lower("${var.server_name}${var.environment_name}")
  resource_group_name     = var.resource_group_name
  location                = var.location
  version                 = var.server_version
  sku_name                = var.sku_name
  storage_mb              = var.storage_size

  administrator_login = random_string.random_string[0].result
  administrator_login_password = azurerm_key_vault_secret.key_vault_password[0].value

  ssl_enforcement_enabled = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
  public_network_access_enabled = false

  infrastructure_encryption_enabled = var.encryption_enabled
  backup_retention_days = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  create_mode = var.create_mode
  creation_source_server_id = var.source_server_id
  auto_grow_enabled = var.auto_grow_enabled

  identity {
    type = "SystemAssigned"
  }

  dynamic "threat_detection_policy" {
    for_each = var.threat_detection_policy == null ? {} : { content = var.threat_detection_policy}
    content {
      enabled                         = threat_detection_policy.value["enabled"]
      retention_days                  = threat_detection_policy.value["retention_days"]
      disabled_alerts                 = threat_detection_policy.value["disabled_alerts"]
      email_account_admins            = threat_detection_policy.value["email_account_admins"]
      email_addresses                 = threat_detection_policy.value["email_addresses"]
      storage_account_access_key      = threat_detection_policy.value["storage_account_access_key"]
      storage_endpoint                = threat_detection_policy.value["storage_endpoint"]
    }
  }
  tags = local.tags
  lifecycle {
    ignore_changes = [
      tags ["buildstatus"],
      tags ["postBuildConfig"]
    ]
  }
}

resource "azurerm_postgresql_database" "postgresql_database" {

  for_each = var.databases_config
  name                = lower("${each.key}${var.environment_name}")
  server_name         = var.create_server ? azurerm_postgresql_server.postgres_server[0].name : var.server_name
  resource_group_name = var.resource_group_name
  collation           = each.value.db_collation
  charset             = each.value.db_charset
}



 resource "azurerm_private_endpoint" "postgres_privateendpoint" {

   count = var.create_server ? 1 : 0

   name                = lower("${var.server_name}-${var.environment_name}-pe")
   location            = var.location
   resource_group_name = var.resource_group_name
   subnet_id           = data.azurerm_subnet.db_subnet.id
   tags                = local.tags

   private_service_connection {
     name = lower("${var.server_name}-${var.environment_name}-pe-con")
     is_manual_connection = false
     private_connection_resource_id = azurerm_postgresql_server.postgres_server[0].id
     subresource_names = ["postgresqlSever"]
   }
 }

  resource "azurerm_key_vault_access_policy" "postgres_server_kv_policy" {

    count = var.create_server ? 1 : 0

    key_vault_id            = data.azurerm_key_vault.key_vault.id
    tenant_id               = azurerm_postgresql_server.postgres_server[0].identity[0].tenant_id
    object_id               = azurerm_postgresql_server.postgres_server[0].identity[0].principal_id
    key_permissions         = ["Get", "UnwrapKey", "WrapKey"]
    secret_permissions      = []
    certificate_permissions = []
    storage_permissions     = []

}

  resource "azurerm_postgresql_server_key" "postgres_cmk" {

    count = var.create_server ? 1 : 0

    server_id        = azurerm_postgresql_server.postgres_server[0].id
    key_vault_key_id = data.azurerm_key_vault_key.encryption_key.id
  }


