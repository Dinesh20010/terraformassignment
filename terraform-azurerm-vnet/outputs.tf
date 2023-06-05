output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "app_subnet_id" {
  description = "ID of the application-tier subnet"
  value       = azurerm_subnet.app_subnet.id
}

output "db_subnet_id" {
  description = "ID of the database-tier subnet"
  value       = azurerm_subnet.db_subnet.id
}

output "app_nsg_id" {
  description = "ID of the application-tier network security group"
  value       = azurerm_network_security_group.app_nsg.id
}

output "db_nsg_id" {
  description = "ID of the database-tier network security group"
  value       = azurerm_network_security_group.db_nsg.id
}