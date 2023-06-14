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
