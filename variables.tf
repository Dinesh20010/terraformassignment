variable "tenant_resource_group_name" {
  description = "The anem of predefined resource group created while onboarding a tenant"
  type = string
}

variable "resource_group_name" {
  type = string
  default = ""
  description = "(OPTIONAL) Name of an existing Azure resource group from which to fetch the tags"
}

variable "location" {
  description = "Location to create the azure resources"
  type = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "app_subnet_name" {
  description = "Name of the application-tier subnet"
  type        = string
}

variable "db_subnet_name" {
  description = "Name of the database-tier subnet"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "app_subnet_cidr" {
  description = "CIDR block for the application-tier subnet"
  type        = string
}

variable "db_subnet_cidr" {
  description = "CIDR block for the database-tier subnet"
  type        = string
}

variable "app_nsg_ports" {
  description = "Ports to allow in the application-tier network security group"
  type        = list(number)
  default     = [8080, 80, 443]
}

variable "db_nsg_ports" {
  description = "Ports to allow in the database-tier network security group"
  type        = list(number)
  default     = [3306, 1433, 5432]
}

variable "app_nsg_name" {
  description = "Name of the application-tier network security group"
  type        = string
}

variable "db_nsg_name" {
  description = "Name of the database-tier network security group"
  type        = string
}

variable "storage_account_name" {
  description = "storage account name, should start with 'xyzcorspl' prefix only if content of the storage is intended to be accessed via internet"
  type = string
  validation {
    condition = length(var.storage_account_name) >= 3 && length(var.storage_account_name) <= 24
    error_message = "The storage account name variable name must be 3-24 characters in length"
  }
}

variable "account_kind" {
  description = "Defines the kind of account. Valid options are Blobstroage, Blockblobstorage, filestorage, Storage and StorageV2"
  type = string
  default = "StorageV2"
}

variable "account_tier" {
  description = "Defines the tier to use for this storage account. Valid options are Standard and Premium."
  type = string
  default = "Standard"
  validation {
    condition = contains(["Standard", "Premium"], var.account_tier)
    error_message = "The Storage account tier should be one of the following: Standard, Premium."
  }
}

variable "account_replication_type" {
  description = "Storage account replication type, e.g LRS, ZRS, GRS etc."
  type = string
  validation {
    condition = contains(["LRS","GRS","RAGRS","ZRS","GZRS","RAGZRS"], var.account_replication_type)
    error_message = "the storage account replication type should be one of the following: LRS,GRS,RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "enable_hns" {
  description = "True or False for enabling large file share."
  type = bool
  default = false
}

variable "large_file_share_enabled" {
  description = "True or False for enabling large file share"
  type = bool
  default = false
}

variable "blob_properties" {
  description = "optional blob properties"
  type = any
  default = null
}

variable "key_vault_resource_group" {
  description = "Pre-existing Resouce group containing the Azure Key vault for the Customer Managed key"
  type = string
}

variable "Key_vault_name" {
  description = "Pre-existing Azure Key vault containing the Customer Managed key"
  type = string
}

variable "encryption_key_name" {
  description = "Pre-existing customer managed key to use for encrypting the storage account."
  type = string
}

variable "private_endpoint_subresources" {
  description = "List of the required subresources for the Private endpoints e.g. blob, dfs, file, queue, table"
  type = list(string)
  default = ["blob"]
}

variable "vnet_rg_name" {
  description = "Pre-existing resource group containing the spoke VNET and subnets, to use for Private Endpoint"
  type = string
}

variable "subnet_name" {
  description = "Pre-existing Subnet, to use for Private Endpoint"
  type = string
}

# Storage-Subresources
# Optional Only required for storage container creation
variable "container_list" {
  description = "List of containers to create and their access levels."
  type = list(object({ name = string, access_type = string}))
  default = []
}

variable "file_share_list" {
  description = "List of fileshare to create and their quota"
  type = list(object({name = string, quota = number}))
  default = []
}

variable "table_list" {
  description = "list of storage tables."
  type = list(string)
  default = []
}

variable "queue_list" {
  description = "list of storages queues"
  type = list(string)
  default = []
}

variable "dfs_list" {
  description = "List of storage queues"
  type = list(string)
  default = []
}


variable "lifecycles" {
  description = "Configure Azure Storage firewall and virtual networks"
  type = list(object({ prefix_match = set(string), tier_to_cool_after_days = number, tier_to_archive_after_days =optional(number), delete_after_days = number, snapshot_delete_after_days = number}))
  default = []
}

variable "enable_static_website" {
  description = "True or False for enabling static website"
  type = bool
  default = false
}

variable "index_document" {
  description = "Index page for static website (ex. Index.html)"
  type = string
  default = ""
}

variable "error404_document" {
  description = "Error 404 Page for static website (ex. error.html)"
  type = string
  default = ""
}

variable "access_tier" {
  description = "Defines the access tier for Blobstorage, Filestorage and StorageV2 accounts. Valid options are Hot and Cool"
  type = string
  default = "Hot"
}

variable "xyz_net_resource_group_name" {
  description = "Resouce group containing the xyz networking resources"
  type = string
}

variable "xyz_vnet_name" {
  description = "xyz virtual network name"
  type = string
}

variable "vm_name_suffix" {
  description = "2 digit or characters code used as application discretionary"
  type = string
  default = "x2"
  validation {
    condition = (
    length(var.vm_name_suffix) == 2 &&
    can(regex("[0-9A-Za-z]{2}", var.vm_name_suffix))
    )
    error_message = "Invalid vm_name_suffix Value."
  }
}

variable "vm_scale_set_name" {
  description = "name of virtual machine scale set"
  type = string
}

variable "instances" {
  description = "Number of Instances Initialy deployed withing scale set"
  type = number
}

variable "user_assigned_identities" {
  description = "Map of UAMI names and resource groups."
  type = map(object({
    uami_name = string
    uami_rg_name = string
  }))
  default = null
}

variable "bootstrap_script" {
  description = "Path to bootstrap script."
  type = string
}

variable "disk_encryption_set_name" {
  description = "disk encryption set name."
  type = string
}

variable "disk_encryption_set_rg_name" {
  description = "disk encryption set name resource group name."
  type = string
}

variable "virtual_machine_size" {
  description = "The Virtual machine SKU for the scale set, default Is Standard_DS3_v2"
  type = string
}

variable "os_upgrade_mode" {
  description = "Specifies how upgrades (e.g. changing the Image/SKU) Sshould be performed to virtual machine instances "
  type = string
}

variable "load_balancer_sku" {
  description = "The SKU of the Azure Load Balancer. Accepted Values are basic and Standard"
  type = string
}

variable "bootstrap_params" {
  description = "Bootstrap script Parameters."
  type = map(string)
  default = {}
}

variable "load_balancer_frontend_port" {
  description = "Port to be forwarded through the load balancer to the Vms"
  type = number
}

variable "load_balancer_backend_port" {
  description = "Linux Vm port to be connected via load balancer."
  type = number
}

variable "azurerm_probe_name" {
  description = "Azure Load balancer port probe name"
  type = string
}

variable "azurerm_probe_port" {
  description = "Azure probe port"
  type = string
}

variable "load_balancer_name" {
  description = "Azure Load balancer Name"
  type = string
}

variable "frontend_configuration_name" {
  description = "Load Balancer Frontend configuration name"
  type = string
}

variable "configuration_allocation" {
  description = "Private Ip Address configuration"
  type = string
}

variable "load_balancer_protocol" {
  description = "Loan Balancer protocol"
  type = string
}

variable "disk_caching" {
  description = "Data Disk Caching"
  default = string
}

variable "disk_type" {
  description = "storage account type"
  default = string
}

variable "disk_option" {
  description = "data disk option"
  default = string
}

variable "disk_size_gb" {
  description = "Data disk size gb"
  default = string
}

variable "network_interface_name" {
  description = "Network Interface name"
  default = string
}

variable "ip_configuration_name" {
  description = "Ip configuration name"
  default = string
}

variable "extension_name" {
  description = "scale set resources extension name"
  type = string
}

variable "extension_publisher" {
  description = "Scale set resources extension punlisher"
  type = string
}

variable "extension_type" {
  description = "scale set resources extension type"
  type = string
}

variable "extension_version" {
  description = "scale set resources extension type version"
  type = string
}

variable "backend_address_pool_name" {
  description = "load balance address pool name"
  type = string
}

variable "load_balancer_rule_name" {
  description = "Load balance address pool rule name"
  type = string
}

variable "vm_password_key_vault_name" {
  description = "Name of keyvault where password are stored"
  type = string
}

variable "vm_password_key_vault_resource_group" {
  description = "Name of resource group where the vm password key vault is created"
  type = string
}

variable "environment_name" {
  description = "Logical environment name within your subscription"
  type = string
  default = null
}

variable "server_name" {
  description = "Server name without an environment suffix, eg. postgresql-srv01."
  type = string
  default = null
}

variable "server_version" {
  description = "Specifies the version of PostgreSQL to use. Valid values are 9.5, 9.6, 10, 10.0 and 11, by default 11"
  type = string
  default = "11"
}

variable "sku_name" {
  description = "Specifies the SKU Name for this PostgreSQL server. The Name of the SKU, follows the tier + family + cores pattern (e.g. B_Gen4_1, GP_Gen5_8)."
  type = string
  default = "GP_Gen5_2"
}

variable "storage_size" {
  description = "Storage size, in megabytes, of the Azure database for PostgreSQL server."
  type = string
  default = "5120"
}

variable "encryption_enabled" {
  description = "Enabling encryption on the server level is not recommended. It causes substantial performance degradation and is not supported by Microsoft. More Info: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server#infrastructure_encryption_enabled"
  type = bool
  default = false
}

variable "backup_retention_days" {
  description = "Backup retention days for the server, supported values are between 7 and 35 days."
  type = string
  default = "35"
}

variable "geo_redundant_backup_enabled" {
  description = "This allows you to choose between locally redundant or geo-redundant backup storage in the General Purpose and Memory Optimized tiers."
  type = bool
  default = false
}

variable "create_mode" {
  description = "This creation mode. Can be used to restore or replicate existing servers. Possible values are Default, Replica, GeoRestore, and PointInTimeRestore."
  type = string
  default = false
}

variable "auto_grow_enabled" {
  description = "Storage auto-grow prevents your server from running out of storage."
  type = bool
  default = true
}

variable "databases_config" {
  description = "Map of objects with parameters for Postgres database. If empty, no database will be created. Keys are names of databases to be created."
  type = map(object({
    db_collation = string
    db_charset   = string
  }))
  default = {}
}

variable "key_vault_name" {
  description = "Name of the Azure Keyvault containing the Customer Managed Key."
  type = string
}

variable "billingReference" {
  description = "billing Reference number for tagging."
  type = string
}

variable "cmdbReference" {
  description = "cmdb Reference for tagging"
  type = string

}

variable "additional_tags" {
  type = map(string)
  default = {}
  description = "(OPTIONAL) Map of additional tags to be appended to the tags from the azure subscription or resource group"
}

variable "only_mandatory_tags" {
  type = bool
  default = true
  description = "(OPTIONAL) If true then return the mandatory XYZ tags, if false then return all tags. Defaults to true"
}

variable "mandatory_tag_keys" {
  type = list(string)
  default = ["billingReference", "cmdbReference", "opEnvironment", "hostingRestrictions"]
  description = "(OPTIONAL) List of tag keys to filter - defaults to the mandatory tag keys, [\"billingReference\", \"cmdbReference\", \"opEnvironment\", \"hostingRestrictions\"], but can be overrided with other values and subset of values."
}