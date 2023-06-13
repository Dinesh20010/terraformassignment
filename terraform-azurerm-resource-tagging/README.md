# Terraform Module - terraform-azurerm-resource-tagging

# Requirements

#### This module has been certified with the below set of provider versions.

#### Please ensure you are using the below listed versions to rule out any provider related issues.

| NAME      | Version  |
|-----------|----------|
| Terraform | 1.3.0    | 
| azurerm   | 3.24.0   |

<font size=”2”> If you are using more than one module from registry, it will automatically use the latest provider version held within the module. in case of inoperability with the multiple provider versions. </font>

# About

<font size=”2”> The purpose of this module is to provide users of the modle a way to fetch tags from the current Azure Subscription or an existing Resource group from (in Azure subscription). The output of this module will be two Terraform ``map(string)`` data objects - one for the tags from the subscription and the other for the tags from the resource group. These outputs  </font>
