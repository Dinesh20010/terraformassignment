output "linux_virtual_machine_scale_set" {
  value = azurerm_linux_virtual_machine_scale_set.vmss
  sensitive = true
  description = "A terraform object reference to the full azurerm_linux_virtual_machine_scale_set resource."
}

output "load_balancer_private_ip" {
  value = azurerm_lb.vmss.private_ip_address
  description = "IP address of the load balances which is created for vmss."
}

output "admin_password" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.admin_password
  sensitive = true
  description = "Admin password set for the Vmss"
}