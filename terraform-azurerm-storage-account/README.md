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

<font size=”2”> The purpose of this module is to provide users of the modle a way to fetch tags from the current Azure Subscription or an existing Resource group from (in Azure subscription). The output of this module will be two Terraform ``map(string)`` data objects - one for the tags from the subscription and the other for the tags from the resource group. These outputs from terraform can be used as inputs into other Terraform modules and resources - as a result there is no need to write your own utility to fetch tags, combine tags, override tags or hardcode tags anywhere in any files or CI/CD tools - you can use this module as a utility. This module will do everything based on the different ways this module can be invoked.
  
  This module doesn't use any external scripts, it uses Terraform data lookups for ``azurerm_subscription`` and ``azurerm_resource_group`` to get the tags, and uses Terraform functions to manipulate the tags into a final output that a developer can use as inputs into other modules, simply by using native Terraform module composition.</font>
