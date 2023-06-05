variable "xyz_net_resource_group_name" {
  description = "Resouce group containing the xyz networking resources"
  type = string
}

variable "xyz_vnet_name" {
  description = "xyz virtual network name"
  type = string
}

variable "db_subnet_name" {
  description = "xyz subnet name"
  type = string
}

variable "location" {
  description = "location to crate Azure resources"
  type = string
}

variable "environment_name" {
  description = "Logical environment name within your subscription"
  type = string
  default = null
}

variable "resource_group_name" {
  description = "Name of the resource group to create and place your resources in."
   type = string
}

variable "create_server" {
  description = "True if server has to be created. False if it already exists."
  type = bool
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

variable "source_server_id" {
  description = "For creation modes other than Default, the source server ID to use."
  type = string
  default = null
}

variable "auto_grow_enabled" {
  description = "Storage auto-grow prevents your server from running out of storage."
  type = bool
  default = true
}

variable "threat_detection_policy" {
  description = "Threat_detection_policy settings for server."
  type = object({
    enabled                         = bool
    disabled_alerts                 = list(string)
    email_account_admins            = bool
    email_addresses                 = list(string)
    retention_days                  = number
    storage_account_access_key      = string
    storage_endpoint                = string
 })
  default = {
    enabled                         = true
    disabled_alerts                 = []
    email_account_admins            = false
    email_addresses                 = []
    retention_days                  = 0
    storage_account_access_key      = null
    storage_endpoint                = null
  }
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

variable "key_vault_resource_group" {
  description = "Name of the resource group where the Azure Keyvault resides."
  type = string
}

variable "encryption_key_name" {
  description = "The Name of the Customer Managed Key which should be used to encrypt this Postgres"
  type = string
}

variable "tags" {
  description = "Name of the resource group where the Azure Keyvault resides."
  type = map(string)
  default = {}
}