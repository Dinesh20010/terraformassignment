variable "resource_group_name" {
  description = "Name of the new resource group to create the storage account"
  type = string
}

variable "storage_account_name" {
  description = "storage account name, should start with 'xyzcorspl' prefix only if content of the storage is intended to be accessed via internet"
  type = string
  validation {
    condition = length(var.storage_account_name) >= 3 && length(var.storage_account_name) <= 24
    error_message = "The storage account name variable name must be 3-24 characters in length"
  }
}

variable "location" {
  description = "Location to create the azure resources"
  type = string
}

variable "tags" {
  description = "Optional map of strings to be used as Azure tags for all resources"
  type = map(string)
  default = {}
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

variable "vnet_name" {
  description = "Pre-existing spoke VNET containing subnets, to use for Private endpoint."
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


