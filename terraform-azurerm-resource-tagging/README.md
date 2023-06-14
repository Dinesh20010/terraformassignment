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

<font size=”2”> The purpose of this module is to provide users of the modle a way to fetch tags from the current Azure Subscription or an existing Resource group from (in Azure subscription). The output of this module will be two Terraform ``map(string)`` data objects - one for the tags from the subscription and the other for the tags from the resource group. These outputs from terraform can be used as inputs into other Terraform modules and resources - as a result there is no need to write your own utility to fetch tags, combine tags, override tags or hardcode tags anywhere in any files or CI/CD tools - you can use this module as a utility. This module will do everything based on the different ways this module can be invoked.
  
  This module doesn't use any external scripts, it uses Terraform data lookups for ``azurerm_subscription`` and ``azurerm_resource_group`` to get the tags, and uses Terraform functions to manipulate the tags into a final output that a developer can use as inputs into other modules, simply by using native Terraform module composition.</font>
  
# Different Use-cases of the Module

1. Fetch tags from Azure subscription: This is the default behaviour when invoked without any configuration, the module will fetch the mandatory tags (``bilingReference``,``cmdbReference``, ``openvironment``, ``hostingRestrictions``) from the Azure Subscription. Any other existing tags will be filtered out and not returned in the output.
2. Fetch tags from Resource Group: Given the name of existing Resource Group, the module will fetch mandatory tags freom this Resource Group. It will also fetch the tags from the Azure Subscription.
3. Fetch tags without mandatory filtering: This applies to both the Subscription and Resource Group. If the boolean flag (``only_mandatory_tags``) is provided with the value set to ``false`` then all tags will be returned in the output, not just mandatory tags. This boolean defaults to true if not provided, so the default behaviour is always to provide only the mandatory tags.
4. Override and/or Additional Tags: This applies to both the Subscription and Resource Group. If the module is invoked with an additional tags map (``additional tags``) then this ``map(string)`` data object will **add-on** to the output any of the tags that do not exist already and provide this as part of the combined Terraform outpur for the Resource Group and/or Subscription. If the ``additional_tags`` map contains tag-keys that exist in the Resource Group/Subscription then the values provided in the ``additional_tags`` will take precedence, so this can be used as an **override** mechanism.
5. Override the madatory tag keys: This applies to both Subscription and Resource Group. The module Defaults to filtering the tags based on the mandatory tag keys (``bilingReference``,``cmdbReference``, ``openvironment``, ``hostingRestrictions``). However if you only want to return a subset of these mandatory tags then you can override the mandatory keys to fetch with a subset by providing a value for ``mandatory_tag_keys``. E.g if ``mandatory_tag_keys`` was provided when invoking the module with just one tag key, then only that one tag key will be returned.
6. Fetch from another Subscription: You can also provide a ``subscription_id`` variable value and if the invoking account/Service Principal has access to the other Subscription then the tags from that will be fetched. if  the ``subscription_id`` is not provided then it defaults to fetching from the current Subscription.
7. Combined use-cases: All of the above can be combined since every input variable to the module is optional so there are multiple use cases.

<font size=”2”> The definition of this logic is in the main.tf file. </font>

# Examples

<font size=”2”> The following is a snippet as an example on how to invoke the module. </font>

````terraform

# Invoke the resource tagging module:

module "tagging" {
  source = "../terraform/terraform-azurerm-resource-tagging"
  version = "1.0.5"
  resource_group_name = var.tenant_resource_group_name
  only_mandatory_tags = true

  additional_tags = { billingRefernce = var.billingReference, cmdbReference = var.cmdbReference }
}
````

# Resources

| Name | Type |
|-----------------|-----------------|
| azurerm_resource_group.resource_group   | data source   |
| azurerm_subscription.subscription   | data source  |

# Inputs

## The following table explains the full list of input variables required by this module.

## The definition of these variables is in the ``variables.tf`` file

| Name         | Description  | Type      | Default   | Required   |
|--------------|--------------|-----------|-----------|------------|
| additional_tags | (OPTIONAL) Map of additional tags to be appended to the tags fetched from the Azure Subscription or Resource Group. Any existing tags with matching keys will be overridden with the additional_tags provided | ``map(string)`` | ``{}`` | no  |
| Mandatory_tag_keys | (OPTIONAL) List of tag keys to filter - defaults to the mandatory tag keys (``bilingReference``,``cmdbReference``, ``openvironment``, ``hostingRestrictions``), but can be overrided with other vaules and subset of values. | ``list(string)`` | [``bilingReference``,``cmdbReference``, ``openvironment``, ``hostingRestrictions``] | no |
| only_mandatory_tags| (OPTIONAL) If true then return the mandatory XYZ tags, if false then return all tags. Defaults to true | bool | true  | no |
| resource_group_name | (OPTIONAL) Name of an existing Azure Resource Group from which to fetch the tags | ``string`` | ``""`` | no |
| subscription_id | (OPTIONAL) ID of an Azure subscription from which to fetch the tags. if not provided, then uses current Azure subscription | ``string`` | ``""`` | no |

# Outputs

  The following table explains the full list of output variables required by this module.

  The definition of these variables is in the ``outputs.tf`` file.

| Name | Description |
|-----------------|-----------------|
| Resource_group_tags | A populated or empty map of strings, containing key-value pairs for the tags fetched from the Resource Group with all rules applied. |
| Subscription_tags | A populated or empty map of strings, containing key-value pairs for the tags fetched from the Subscription with all rules applied. |

<font size=”2”> Both of the outputs will always be provided, empty outputs will be empty map(string)objects, not null values. </font>

<font size=”2”> Using the above output as a reference, the following examples show how to use the granular output references: </font>

- ``module.tagging.subscription_tags`` - this is how to reference the ``map(string)`` object for the subscription tags: ``module "tagging" {....}``
- ``module.tagging.resource_group_tags`` - this is how to reference the ``map(string)`` object for the Resource Group tags: ``module "tagging" {....}``

