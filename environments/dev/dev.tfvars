# Variables for Tagging
tenant_resource_group_name = "tfterraform"
billingReference = "xyz-tf-iac-dev"
cmdbReference = "dev"

# variables for resource group
resource_group_name = "xyztfterraform"
location = "North Europe"

# Vnet Config
resource_group_name   = "xyztfterraform"
location              = "North Europe"
vnet_name             = "xyz-dev-vnet"
app_subnet_name       = "app-subnet"
db_subnet_name        = "db-subnet"
address_space         = ["10.0.0.0/16"]
app_subnet_cidr       = "10.0.1.0/24"
db_subnet_cidr        = "10.0.2.0/24"
app_nsg_name          = "app-nsg"
db_nsg_name           = "db-nsg"
app_nsg_ports         = [8080, 80, 443]
db_nsg_ports          = [3306, 1433, 5432]

# Variables for storage account
storage_account_name = "xyzstorappdev"
account_replication_type = "LRS"
account_kind = "StorageV2"
account_tier = "Standard"
days_before_deletion = 7
enable_hns = true
key_vault_resource_group = "xyzkvappdev"
Key_vault_name = "xyzkvappdevvault"
encryption_key_name = "storageEncrypt-HSM"
private_endpoint_subresources = ["blob"]
large_file_share_enabled = false
sku = "standard"
container_list = [{"name" = "dev", access_type = "private"}]
dfs_list = ["dev"]
enable_static_website = false

# Variables for Linux virtual machine scale sets
azurerm_probe_name = "xyzlbprobeappdev"
azurerm_probe_port = "22"
backend_address_pool_name = "xyzlbbpappdev"
configuration_allocation = "Dynamic"
disk_caching = "ReadWrite"
disk_encryption_set_name = ""
disk_encryption_set_rg_name = ""
disk_option = "Empty"
disk_size_gb = 60
disk_type = "StandardSSD_LRS"
extension_name = "configure-settings"
extension_publisher = "Microsoft.Azure.Extensions"
extension_type = "CustomScript"
extension_version = "2.0"
frontend_configuration_name = ""
instances = "1"
ip_configuration_name = ""
load_balancer_backend_port = "22"
load_balancer_frontend_port = "22"
load_balancer_name = "xyzappdevlb"
load_balancer_protocol = "tcp"
load_balancer_rule_name = "xyzappdevlbrule"
load_balancer_sku = "Basic"
location = "North Europe"
network_interface_name = "nicxyzappdevne"
os_upgrade_mode = "Automatic"
resource_group_name = "xyztfterraform"
app_subnet_name = "app-subnet"
vnet_name = "xyz-dev-vnet"
vnet_rg_name = "xyztfterraform"
user_assigned_identities = {
  uami1 = {
    uami_name = ""
    uami_rg_name = ""
  },
}
virtual_machine_size = "Standard_DS3_v2"
vm_name_suffix = "xyzvmss"
vm_password_key_vault_name = "xyzkvappdevvault"
vm_password_key_vault_resource_group = "xyzkvappdev"
vm_scale_set_name = "xyzkvappdevvmss"

# Variables for postgresql
auto_grow_enabled = true
backup_retention_days = "35"
create_mode = "Default"
databases_config = {
  "xyzmoduledb"  = {
    db_collation = "English_united States.1252"
    db_charset   = "UTF8"
  },
}
encryption_enabled = false
encryption_key_name = "azureCMKPostgreSqlnortheurope-HSM"
geo_redundant_backup_enabled = false
key_vault_name = "xyzkvappdevvault"
key_vault_resource_group = "xyzkvappdev"
location = "North Europe"
resource_group_name = "xyztfterraform"
server_name = "xyzpgsqlappdev"
server_version = "11"
sku_name = "GP_Gen5_2"
storage_size = "5120"
tags = {}
xyz_net_resource_group_name = "xyztfterraform"
db_subnet_name = "db-subnet"
xyz_vnet_name = "xyz-dev-vnet"

