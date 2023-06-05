output "subscription_tags" {
  value = var.only_mandatory_tags ? merge(local.subscription_filtered_tags, local.additional_tags) : merge(local.subscription_tags, local.additional_tags)
  description = "A populated or empty map of strings, containing key-value pairs for the tags fetched from the subscription with all rules applied"
}

output "resource_group_tags" {
  value = var.resource_group_name != "" ? (var.only_mandatory_tags ? merge(local.resource_group_filtered_tags, local.additional_tags): merge(local.resource_group_tags, local.additional_tags)) : {}
  description = "A populated or empty map of strings, containing key-value pairs for the tags fetched from the resource group with all rules applied"
}