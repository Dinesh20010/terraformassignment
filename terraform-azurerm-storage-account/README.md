# Terraform Module - Storage-account

# Requirements

#### This module has been certified with the below set of provider versions.

#### Please ensure you are using the below listed versions to rule out any provider related issues.

| NAME      | Version  |
|-----------|----------|
| Terraform | 1.3.0    | 
| azurerm   | 3.28.0   |
| null   | 3.1.1   |
| random   | 3.4.3   |
| time   | 0.8.0   |

<font size=”2”> If you are using more than one module from registry, it will automatically use the latest provider version held within the module. in case of inoperability with the multiple provider versions. </font>

# About

<font size=”2”> The purpose of this Terraform module is to provide a consistent and standard approach to create an Azure Storage Account. Using this module will enforce the consumer to provide the mandatory properties of an Azure Storage account so that the Azure criteria is met.

  The definition of the input variables, output attributes and the resource definition are located at the root of the repository.</font>
  
## References:
- [azurerm_storage_account Terraform Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) 

# Prerequisites

<font size=”2”> This module uses the below data sources as input: </font>

| Name | Type |
|-----------------|-----------------|
| azurerm_client_config.current   | data source   |
| azurerm_key_vault.encryption_vault   | data source |
| azurerm_key_vault_key.storage_cmk   | data source |
| azurerm_subnet.subnet   | data source  |

# Example
## The following is a snippet as an example on basic use of the module:

```terraform
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
````

# Resources

| Name | Type |
|-----------------|-----------------|
| azurerm_key_vault_access_policy.storage_keyvault_accesspolicy   | resource   |
| azurerm_private_endpoint.private_endpoint   | resource   |
| azurerm_storage_account.storage_account   | resource |
| azurerm_storage_container.storage_account_container | resource  |
| azurerm_storage_data_lake_gen2_filesystem.storage_account_dfs   | resource   |
| azurerm_storage_management_policy.storage_account_lcpolicy   | resource   |
| azurerm_storage_queue.storage_account_queues | resource  |
| azurerm_storage_share.storage_account_fileshare   | resource   |
| azurerm_storage_table.storage_account_tables | resource   |
| azurerm_user_assigned_identity.storage_account_uami  | resource  |
| time_sleep.dns_update_checker  | resource  |
| azurerm_subnet.xyz_subnet  | data source  |

# Inputs

## The following table explains the full list of input variables required by this module.

## The definition of these variables is in the ``variables.tf`` file

| Name         | Description  | Type      | Default   | Required   |
|--------------|--------------|-----------|-----------|------------|
| account_kind | Defines the kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. | ``string`` | ``"StorageV2"`` | no |
| account_replication_type | Storage Account replication type, e.g. LRS, ZRS, GRS etc | ``string`` | n/a | yes |
| account_tier | Defines the tier to use for this storage account. Valid options are Standard and Premium | ``string`` | ``"Standard"`` | no |
| blob_properties | Optional Blob properties | ``any``  | ``null`` | no |
| container_list | List of containers to create and their access levels | ``list(object({ name = string, access_type = string}))`` | ``[]``  | no |
| dfs_list | List of storage queues | ``list(string)``  | ``[]`` | no |
| enable_hns| True or False for enabling hierarchical namespace for ADLS Gen2 | ``bool`` | ``false`` | no |
| enable_static_website | True or False for enabling static website. | ``bool`` | ``false`` | no |
| encryption_key_name | Pre-existing customer Managed key to use for encrypting the storage account | ``string`` | n/a | yes |
| error404_document | Error 404 page for static website (ex.error.html) | ``string`` | ``""`` | no |
| file_share_list | List of Fileshare to create and their quota | ``list(object({ name = string, quota = number}))``  | ``[]`` | no |
| Index_document | Indes page for static website (ex.indes.html) | ``string`` | ``""`` | no |
| Key_vault_name | Pre-existing Azure key vault containing the Customer Managed Key. | ``string`` | ``n/a`` | yes |
| Key_vault_resource_group | Pre-existing Resource group containing the Customer Managed Key. | ``string`` | ``n/a`` | yes |
| large_file_share_enabled | True or False for enabling large file share | ``bool`` | ``null`` | no |
| lifecycles | Cofingure Azure Storage firewalls and virtual networks | ``list(object({ prefix_match = set(string), tier_to_cool_after_days = number, tier_to_archive_after_days = optional(number), delete_after_days = number, snapshot_delete_after_days = number }))`` | ``[]`` | no |
| location | Location to create the Azure resources | ``string`` | n/a | yes |
| private_endpoint_subresources | List of the required subresources for the private Endpoints e.g. blob, dfs, file, queue | ``list(string)`` | ["blob"] | no |
| queue_list | List of storages queues | ``list(string)`` | ``[]`` | no |
| resource_group_name | Name of the new Resource Group to create the storage account | ``string`` | n/a | yes |
| storage_account_name | Storage Account name. Should start with 'xyzstor' prefix only if content of the storage is intended to be accessed via internet browser | ``string`` | n/a | yes |
| subnet_name | Pre-existing subnet, to use for Private endpoint | ``string`` | n/a | yes |
| table_list | list of storage tables | ``list(string)`` | n/a | yes |
| Location | Location to create the Azure resources in - should be the region name of your subscription, e.g 'northeurope' | string | n/a | yes |
| network_interface_name | Network Interface name | string | n/a | yes |
| os_upgrade_mode | Specifies how Upgrades (e.g. changing the Image/SKU) should be performed to Virtual Machine Instances. Possible values are Automatic, Manual and Rolling. Defaults to Automatic | string | n/a | yes |
| resource_group_name | Name of the resource group to create and place your resources in | string | n/a | yes |
| tags | Optional map of strings to be used as Azure Tags for all resources. | map(string) | string | n/a | yes |
| xyz_subnet_name | Subnet name, found in the pre-existing virtual network in your subscription.| string | n/a | yes |
| xyz_vnet_name | XYZ virtual network name, found in your subscription | string | n/a | yes |
| xyz_vnet_rg_name | Existing resource group found in your subscription | string | n/a | yes |
| user_assigned_identities | Map of UAMI names and resource groups. | map(object({uami_name = string uami_rg_name = string})) | null | no |
| Virtual_machine_size | The Virtual Machine SKU for the Scale Set, Default is Standard_DS3_v2 | string | n/a | yes |
| vm_name_suffix | 2 digit or characters code used as appliction discretionary | string | ``"X2"``| no |
| vm_password_key_vault_name | Name of Keyvault where Password are stored | string | n/a | yes |
| vm_password_key_vault_resource_group | Name of resource group where the VM Password Key vault is created | string | n/a | yes |
| vm_scale_set_name | Name of Virtual Machine Scale Set | string | n/a | yes |


