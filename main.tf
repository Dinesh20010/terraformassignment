# use Tagging module
module "tagging" {
  source = "../terraform/terraform-azurerm-resource-tagging"
  version = "1.0.5"
  resource_group_name = var.tenant_resource_group_name
  only_mandatory_tags = true

  additional_tags = { billingRefernce = var.billingReference, cmdbReference = var.cmdbReference }
}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.resource_group_name
  tags     = module.tagging.subscription_tags
  lifecycle {
    ignore_changes = [tags]
  }
}

# create Azure network
module "azure_network" {
  source                = "./terraform-azurerm-vnet/"
  version               = "1.0.0"
  resource_group_name   = var.resource_group_name
  location              = var.location
  vnet_name             = var.vnet_name
  app_subnet_name       = var.app_subnet_name
  db_subnet_name        = var.db_subnet_name
  address_space         = var.address_space
  app_subnet_cidr       = var.app_subnet_cidr
  db_subnet_cidr        = var.db_subnet_cidr
  app_nsg_name          = var.app_nsg_name
  db_nsg_name           = var.db_nsg_name
  app_nsg_ports         = var.app_nsg_ports
  db_nsg_ports          = var.db_nsg_ports
}

# Create Storage account
module "storage_account" {
  source = "./terraform-azurerm-storage-account"
  version = "2.1.4"

  resource_group_name = azurerm_resource_group.rg.name
  storage_account_name = var.storage_account_name
  location = var.location
  tags = module.tagging.subscription_tags

  account_replication_type = var.account_replication_type
  account_kind = var.account_kind
  account_tier = var.account_tier
  access_tier = var.access_tier

  enable_hns = var.enable_hns
  large_file_share_enabled = var.large_file_share_enabled

  key_vault_resource_group = var.key_vault_resource_group
  key_vault_name = var.Key_vault_name
  encryption_key_name = var.encryption_key_name

  private_endpoint_subresources = var.private_endpoint_subresources
  vnet_rg_name = var.vnet_rg_name
  vnet_name = var.vnet_name
  subnet_name = var.subnet_name

  # Storage-subresources
  container_list = var.container_list
  file_share_list = var.file_share_list
  table_list = var.table_list
  queue_list = var.queue_list
  dfs_list = var.dfs_list

  # storage account lifecycle management
  lifecycles = var.lifecycles

  # Static website enabled
  enable_static_website = var.enable_static_website

}


# Create linux virtual machine scale set
module "linux_virtual_machine_scale_set" {
  source = "./terraform-azurerm-linux-virtual-machine-scale-sets/"
  version = "1.1.0"

  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  vm_name_suffix = var.vm_name_suffix
  vm_scale_set_name = var.vm_scale_set_name
  app_subnet_name = var.app_subnet_name
  xyz_vnet_name = var.xyz_vnet_name
  xyz_net_resource_group_name = var.xyz_net_resource_group_name
  disk_encryption_set_name = var.disk_encryption_set_name
  disk_encryption_set_rg_name = var.disk_encryption_set_rg_name
  user_assigned_identities = var.user_assigned_identities
  virtual_machine_size = var.virtual_machine_size
  os_upgrade_mode = var.os_upgrade_mode
  load_balancer_sku = var.load_balancer_sku
  load_balancer_frontend_port = var.load_balancer_frontend_port
  load_balancer_backend_port = var.load_balancer_backend_port
  azurerm_probe_name = var.azurerm_probe_name
  frontend_configuration_name = var.frontend_configuration_name
  configuration_allocation = var.configuration_allocation
  load_balancer_protocol = var. load_balancer_protocol
  disk_type = var.disk_type
  disk_caching = var.disk_caching
  disk_option = var.disk_option
  disk_size_gb = var.disk_size_gb
  network_interface_name = var.network_interface_name
  ip_configuration_name = var.ip_configuration_name
  extension_name = var.extension_name
  extension_publisher = var.extension_publisher
  extension_type = var.extension_type
  extension_version = var.extension_version
  backend_address_pool_name = var.backend_address_pool_name
  load_balancer_rule_name = var.load_balancer_rule_name
  tags = module.tagging.subscription_tags
  vm_password_key_vault_resource_group = var.vm_password_key_vault_resource_group
  vm_password_key_vault_name = var.vm_password_key_vault_name
  depends_on = [
  azurerm_resource_group.rg
  ]
  instances = var.instances

}


# create postgresql server
module "postgres" {
  source = "../terraform/terraform-azurerm-postgresql"
  version = "1.0.2"

  xyz_net_resource_group_name = var.xyz_net_resource_group_name
  xyz_vnet_name = var.xyz_vnet_name
  db_subnet_name = var.db_subnet_name
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  environment_name = var.environment_name

  tags = module.tagging.subscription_tags

  # server Parameters
  create_server = true
  server_name = var.server_name
  server_version = var.server_version
  sku_name = var.sku_name
  storage_size = var.storage_size
  encryption_enabled = var.encryption_enabled
  backup_retention_days = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  create_mode = var.create_mode
  auto_grow_enabled = var.auto_grow_enabled

  # database parameters
  databases_config = var.databases_config

  # customer-managed key
  key_vault_name = var.key_vault_name
  key_vault_resource_group = var.key_vault_resource_group
  encryption_key_name = var.encryption_key_name

}















