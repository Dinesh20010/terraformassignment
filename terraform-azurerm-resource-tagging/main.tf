data "azurerm_subscription" "subscription" {
  subscription_id = "var.subscription_id"
}

data "azurerm_resource_group" "resource_group" {
  count = var.resource_group_name != "" ? 1 : 0
  name = var.resource_group_name
}

locals {
  #Validate the tages are provided/fetched, else use an empty map.
  subscription_tags =  try(data.azurerm_subscription.subscription.tags, {})
  resource_group_tags = try(data.azurerm_resource_group.resource_group[0].tags, {})
  additional_tags = try(var.additional_tags, {})

  #Iterate through the mandatory tag keys and get the tags from the map, and create a filtered object as list (map(string))
  tmp_subscription_filtered_tags_list = [{
     for tag_key in var.mandatory_tag_keys : tag_key => lookup(local.subscription_tags, tag_key, null)
    }]

  # Flatten the list(map(string)) from above and restructure it into the correct map(string) format for the tags.
  subscription_filtered_tags = try(zipmap(
    flatten(
      [for item in local.tmp_subscription_filtered_tags_list : keys(item)]
    ),
    flatten(
      [for item in local.tmp_subscription_filtered_tags_list : values(item)]
    )
  ),{})

  # Flatten the list (Map(string)) from above and restructure it into the correct map(string) format for the tags.
  resource_group_filtered_tags = try(zipmap(
    flatten(
      [for item in local.tmp_subscription_filtered_tags_list : keys(item)]
    ),
    flatten(
      [for item in local.tmp_subscription_filtered_tags_list : values(item)]
    )
 ),{})
}