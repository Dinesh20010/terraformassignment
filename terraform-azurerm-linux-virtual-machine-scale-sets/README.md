#  Terraform Module - linux-virtual-machine-scale-sets

### Terraform Module - linux-virtual-machine-scale-sets
- Requirements
- About
- Prerequisites
- Examples
- Inputs
- VMSS Password
- VMSS password Prerequisite
- Outputs

# Requirements

#### This module has been certified with the below set of provider versions.

#### Please ensure you are using the below listed versions to rule out any provider related issues.

| NAME      | Version  |
|-----------|----------|
| Terraform | 1.3.0    | 
| azurerm   | 3.24.0   |
| random    | 3.4.3    |

If you are using more than one module from registry, it will automatically use the latest provider version held within the module. In case of inoperability with the multiple provider versions.

# About

The purpose of this Terraform Module is to provide a consistent and standard approach to create an Azure Linux Virtual Machine Scale Set. Using this module will enforce the consumer to provide the mandaroty properties of an Azure Linux Virtual Machine Scale Set so thar the Azure criteria is met.

## References:
- [linux-virtual-machine-scale-sets Terraform Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set)

# Example
## The following is a snippet as an example on basic use of the module:

```terraform

# Create linux virtual machine scale set

module "linux_virtual_machine_scale_set" {
  source = "./terraform-azurerm-linux-virtual-machine-scale-sets/"
  version = "1.1.0"

  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  vm_name_suffix = var.vm_name_suffix
  vm_scale_set_name = var.vm_scale_set_name
  app_subnet_name = var.app_subnet_name
  xyz_vnet_name = var.xyz_vnet_name
  xyz_net_resource_group_name = var.xyz_net_resource_group_name
  disk_encryption_set_name = var.disk_encryption_set_name
  disk_encryption_set_rg_name = var.disk_encryption_set_rg_name
  user_assigned_identities = var.user_assigned_identities
  virtual_machine_size = var.virtual_machine_size
  os_upgrade_mode = var.os_upgrade_mode
  load_balancer_sku = var.load_balancer_sku
  load_balancer_frontend_port = var.load_balancer_frontend_port
  load_balancer_backend_port = var.load_balancer_backend_port
  azurerm_probe_name = var.azurerm_probe_name
  frontend_configuration_name = var.frontend_configuration_name
  configuration_allocation = var.configuration_allocation
  load_balancer_protocol = var. load_balancer_protocol
  disk_type = var.disk_type
  disk_caching = var.disk_caching
  disk_option = var.disk_option
  disk_size_gb = var.disk_size_gb
  network_interface_name = var.network_interface_name
  ip_configuration_name = var.ip_configuration_name
  extension_name = var.extension_name
  extension_publisher = var.extension_publisher
  extension_type = var.extension_type
  extension_version = var.extension_version
  backend_address_pool_name = var.backend_address_pool_name
  load_balancer_rule_name = var.load_balancer_rule_name
  tags = module.tagging.subscription_tags
  vm_password_key_vault_resource_group = var.vm_password_key_vault_resource_group
  vm_password_key_vault_name = var.vm_password_key_vault_name
  depends_on = [
  azurerm_resource_group.rg
  ]
  instances = var.instances

}
```
# Resources

| Name | Type |
|-----------------|-----------------|
| azurerm_key_vault_secret.vmss_password   | resource   |
| azurerm_lb.vmss   | resource   |
| azurerm_lb_backend_address_pool.vmss   | resource |
| azurerm_lb_probe.vmss   | resource  |
| azurerm_lb_rule.vmss   | resource   |
| azurerm_linux_virtual_machine_scale_set.vmss   | resource   |
| azurerm_virtual_machine_scale_set_extension.setup_vmss  | resource  |
| random_password.password   | resource   |
| random_string.random | resource   |
| azurerm_disk_encryption_set.disk_encrption_set  | data source  |
| azurerm_key_vault.key_vault  | data source  |
| azurerm_subnet.xyz_subnet  | data source  |
| azurerm_user_assigned_identiry.uami_list  | data source  |



