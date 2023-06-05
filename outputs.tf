output "linux_virtual_machine_scale_set" {
  value = module.linux_virtual_machine_scale_set.linux_virtual_machine_scale_set
  sensitive = true
  description = "A terraform object reference to the full azurerm_linux_virtual_machine_scale_set resource."
}

output "load_balancer_private_ip" {
  value = module.linux_virtual_machine_scale_set.load_balancer_private_ip
  description = "IP address of the load balances which is created for vmss."
}

output "admin_password" {
  value = module.linux_virtual_machine_scale_set.admin_password
  sensitive = true
  description = "Admin password set for the Vmss"
}

output "storage_account" {
  value = module.storage_account.storage_account
  description = "A Terraform object reference to the full ``azurerm_storage_account`` resource."
  sensitive = true
}

output "storage_account_private_endpoints" {
  value = module.storage_account.storage_account_private_endpoints
  description = "A Terraform object with nested object references to the full ``azurerm_private_endpoint`` resources for each of the Private Endpoint connections."
}

output "storage_account_containers" {
  value = length(module.storage_account.storage_account_containers) > 0 ? module.storage_account.storage_account_containers : null
  description = "A Terraform object reference to the full ``azurerm_storage_container`` resource."
}

output "storage_account_shares" {
  value = length(module.storage_account.storage_account_shares) > 0 ? module.storage_account.storage_account_shares : null
  description = "A Terraform object reference to the full ``azurerm_storage_share`` resource."
}

output "storage_account_queues" {
  value = length(module.storage_account.storage_account_queues) > 0 ? module.storage_account.storage_account_queues : null
  description = "A Terraform object reference to the full ``azurerm_storage_queue`` resource."
}

output "out_databases" {
  value = module.postgres.postgresql_databases
  sensitive = true
  description = "postgres database"
}

output "out_server" {
  value = module.postgres.postgresql_server
  sensitive = true
  description = "postgres server"
}



