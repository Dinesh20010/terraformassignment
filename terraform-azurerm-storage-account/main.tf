locals {
  telemetry_tags = {
    TELEMETRY_TAG_KEY = "TELEMETRY_TAG_VALUES"
  }
  tags =  merge(var.tags, local.telemetry_tags)
}

# Get the details of the current logged in client config.
data "azurerm_client_config" "current" {}

# Get the details of the Azure key vault to use for the CMK.
data "azurerm_key_vault" "encryption_vault" {
  name                = var.encryption_key_name
  resource_group_name = var.key_vault_resource_group
}

# Get the details of the encryption key to use as the CMK.
data "azurerm_key_vault_key" "storage_cmk" {
  key_vault_id = data.azurerm_key_vault.encryption_vault.id
  name         = var.encryption_key_name
}

# Get the details of the subnet to use for the private endpoint.
data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.vnet_rg_name
  virtual_network_name = var.vnet_name
}

# Create a UAMi for SA CMK encryption
resource "azurerm_user_assigned_identity" "storage_account_uami" {
  location            = var.location
  name                = join("-", [var.storage_account_name, "uami"])
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

#Provide Key Permission to newly created UAMI
resource "azurerm_key_vault_access_policy" "storage_keyvault_accesspolicy" {
  key_vault_id = data.azurerm_key_vault.encryption_vault.id
  object_id    = azurerm_user_assigned_identity.storage_account_uami.principal_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  key_permissions = ["Get", "UnwrapKey", "WrapKey"]
}

# Create/Update the Azure storage Account.
resource "azurerm_storage_account" "storage_account" {
  depends_on = [azurerm_key_vault_access_policy.storage_keyvault_accesspolicy]
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name

  location                 = var.location
  tags                     = local.tags
  account_kind             = var.account_kind
  account_tier             = var.access_tier
  account_replication_type = var.account_replication_type
  large_file_share_enabled = var.large_file_share_enabled
  access_tier              = var.access_tier

  enable_https_traffic_only        = true
  min_tls_version                  = "TLS1_2"
  allow_nested_items_to_be_public  = false
  is_hns_enabled                   = var.enable_hns
  cross_tenant_replication_enabled = false

  dynamic "blob_properties" {
    for_each = (try(var.blob_properties, null) != null) ? [1] : []
    content {
      versioning_enabled              = lookup(var.blob_properties, "versioning_enabled", null)
      change_feed_enabled             = lookup(var.blob_properties, "change_feed_enabled", null)
      change_feed_retention_in_days   = lookup(var.blob_properties, "change_feed_retention_in_days", null)
      default_service_version         = lookup(var.blob_properties, "default_service_version", null)
      last_access_time_enabled        = lookup(var.blob_properties, "last_access_time_enabled", null)

      dynamic "delete_retention_policy" {
        for_each = (try(var.blob_properties.delete_rentention_policy, null) != null) ? [1] : []
        content {
          days = lookup(var.blob_properties.delete_rentention_policy, "days", null )
        }
      }
     dynamic "cors_rule" {
       for_each = (try(var.blob_properties.cors_rule, null) != null) ? [1] : []
       content {
         allowed_headers = lookup(var.blob_properties.cors_rule, "allowed_headers", null)
         allowed_methods = lookup(var.blob_properties.cors_rule, "allowed_methods", null)
         allowed_origins = lookup(var.blob_properties.cors_rule, "allowed_origins", null)
         exposed_headers = lookup(var.blob_properties.cors_rule, "exposed_headers", null)
         max_age_in_seconds = lookup(var.blob_properties.cors_rule, "max_age_in_seconds", null)
       }
     }
    dynamic "container_delete_retention_policy" {
      for_each = (try(var.blob_properties.container_delete_retention_policy, null) != null) ? [1] : []
      content {
        days = lookup(var.blob_properties.container_delete_retention_policy, "days", null )
      }
    }
  }
}
  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.storage_account_uami.id]
  }

  customer_managed_key {
    key_vault_key_id          = data.azurerm_key_vault_key.storage_cmk.id
    user_assigned_identity_id = azurerm_user_assigned_identity.storage_account_uami.id
  }

  network_rules {
    default_action = "Deny"
    bypass         = ["logging", "Metrics", "AzureServices"]
    virtual_network_subnet_ids = [data.azurerm_subnet.subnet.id]
  }

  lifecycle { ignore_changes = [azure_files_authenctication] }

  dynamic "static_website" {
    for_each = var.enable_static_website ? [1] : []
    content {
      index_document = var.index_document != null ? var.index_document : null
      error_404_document = var.error404_document != null ? var.error404_document : null
    }
  }
}

# Create/Update the Private Endpoint for the storage account based on provided subresources.

resource "azurerm_private_endpoint" "private_endpoint" {
  for_each = toset(var.enable_hns ? distinct(concat(["dfs"], var.private_endpoint_subresources)) : distinct(var.private_endpoint_subresources))
  location            = var.location
  name                = join("-", [azurerm_storage_account.storage_account.name, "pvtendpt", each.value])
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.subnet.id
  tags                = local.tags

  private_service_connection {
    is_manual_connection           = false
    name                           = join("-", [azurerm_storage_account.storage_account.name, "pvtsvcconn", each.value])
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = tolist([each.value])
  }
}

resource "time_sleep" "dns_update_checker" {
  count = length(var.container_list) > 0 || length(var.file_share_list) > 0 || length(var.queue_list) > 0 || length(var.table_list) > 0 || length(var.dfs_list) > 0 ? 1 : 0
  depends_on = [azurerm_private_endpoint.private_endpoint]
  create_duration = "200s"
}

#--------------------------------------------------
# Optional only required for Storage Container Creation
#--------------------------------------------------

resource "azurerm_storage_container" "storage_account_container" {
  depends_on = [
    time_sleep.dns_update_checker
  ]
  count                 = length(var.container_list)
  name                  = var.container_list[count.index].name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = var.container_list[count.index].access_type
}

#--------------------------------------------------
# Optional only required for Storage Fileshare Creation
#--------------------------------------------------
resource "azurerm_storage_share" "storage_account_fileshare" {
  depends_on = [
    time_sleep.dns_update_checker
  ]
  count                = length(var.file_share_list)
  name                 = var.file_share_list[count.index].name
  quota                = var.file_share_list[count.index].quota
  storage_account_name = azurerm_storage_account.storage_account.name
}

#--------------------------------------------------
# Optional only required for Storage Tables Creation
#--------------------------------------------------
resource "azurerm_storage_queue" "storage_account_queues" {
  depends_on = [
    time_sleep.dns_update_checker
  ]
  count                = length(var.queue_list)
  name                 = var.queue_list[count.index]
  storage_account_name = azurerm_storage_account.storage_account.name
}

#--------------------------------------------------
# Optional only required for data_lake_gen2_filesystem Queue Creation
#--------------------------------------------------
resource "azurerm_storage_data_lake_gen2_filesystem" "storage_account_dfs" {
  depends_on = [
    time_sleep.dns_update_checker
  ]
  count              = length(var.dfs_list)
  name               = var.dfs_list[count.index]
  storage_account_id = azurerm_storage_account.storage_account.id
}

#--------------------------------------------------
# Storage Lifecycle Management
#--------------------------------------------------
resource "azurerm_storage_management_policy" "storage_account_lcpolicy" {
  count = length(var.lifecycles) == 0 ? 0 : 1
  storage_account_id = azurerm_storage_account.storage_account.id

  dynamic "rule" {
    for_each = var.lifecycles
    iterator = rule
    content {
      name = "rule${rule.key}"
      enabled = true
      filters {
        prefix_match = rule.value.prefix_match
        blob_types   =  ["blockBlob"]
      }
      actions {
        base_blob{
        tier_to_cool_after_days_since_modification_greater_than = rule.value.tier_to_cool_after_days
        tier_to_archive_after_days_since_modification_greater_than = rule.value.tier_to_archive_after_days
        delete_after_days_since_modification_greater_than = rule.value.delete_after_days
}
        snapshot {
          delete_after_days_since_creation_greater_than = rule.value.snapshot_delete_after_days
        }
      }
    }
  }
}
