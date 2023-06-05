output "storage_account" {
  value = azurerm_storage_account.storage_account
  description = "A Terraform object reference to the full ``azurerm_storage_account`` resource."
  sensitive = true
}

output "storage_account_private_endpoints" {
  value = azurerm_private_endpoint.private_endpoint
  description = "A Terraform object with nested object references to the full ``azurerm_private_endpoint`` resources for each of the Private Endpoint connections."
}

output "storage_account_containers" {
  value = length(azurerm_storage_container.storage_account_container) > 0 ? azurerm_storage_container.storage_account_container : null
  description = "A Terraform object reference to the full ``azurerm_storage_container`` resource."
}

output "storage_account_shares" {
  value = length(azurerm_storage_share.storage_account_fileshare) > 0 ? azurerm_storage_share.storage_account_fileshare : null
  description = "A Terraform object reference to the full ``azurerm_storage_share`` resource."
}

output "storage_account_queues" {
  value = length(azurerm_storage_queue.storage_account_queues) > 0 ? azurerm_storage_queue.storage_account_queues : null
  description = "A Terraform object reference to the full ``azurerm_storage_queue`` resource."
}

output "storage_account_dfs" {
  value = length(azurerm_storage_data_lake_gen2_filesystem.storage_account_dfs) > 0 ? azurerm_storage_data_lake_gen2_filesystem.storage_account_dfs : null
  description = "A Terraform object reference to the full ``azurerm_storage_data_lake_gen2_filesystem`` resource."
}

output "storage_account_lcpolicies" {
  value = length(azurerm_storage_management_policy.storage_account_lcpolicy) > 0 ? azurerm_storage_management_policy.storage_account_lcpolicy : null
  description = "A Terraform object reference to the full ``azurerm_storage_management_policy`` resource."
}