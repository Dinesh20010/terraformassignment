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

# Inputs

## The following table explains the full list of input variables required by this module.

## The definition of these variables is in the ``variables.tf`` file

| Name         | Description  | Type      | Default   | Required   |
|--------------|--------------|-----------|-----------|------------|
| azurerm_probe_name | Azure load balancer port probe name | string | n/a | yes  |
| azurerm_probe_name | Azure Probe port | Number  | n/a | yes |
| backend_address_pool_name | Load balance address pool name | string | n/a  | yes |
| bootstrap_param  | Bootstrap script parameters | map(string) | {} | no |
| bootstrap_script | Path to bootstrap script. | string | n/a  | yes |
| configuration_script | Private IP address configuration | string  | n/a | yes |
| disk_caching | Data disk caching | string | n/a | yes |
| disk_encryption_set_name | Disk Encryption Set name | string | n/a | yes |
| disk_encryption_set_rg_name | Disk Encryption Set resource group name | string | n/a | yes |
| disk_option | Data disk option | string | n/a | yes |
| disk_size_gb | Data disk size gb | number | n/a | yes |
| disk_type | Storage account type | string | n/a | yes |
| extension_name | Scale Set Resources extension name | string | n/a | yes |
| extension_publisher | Scale Set Resources extension publisher | string | n/a | yes |
| Frontend_configuration_name | Load balancer frontend configuration name | string | n/a | yes |
| Instances | Number of instances initialy deployed within scale set | Number | n/a | yes |
| Ip_config_name | Ip configuration name | string | n/a | yes |
| load_balancer_backend_port | Linux VM port to be connected via load balancer | Number | n/a | yes |
| load_balancer_frontend_port | Port to be forwarded through the load balancer to the VMs | Number | n/a | yes |
| load_balancer_name | Azure load balancer name | string | n/a | yes |
| load_balancer_protocol | Load balancer protocol | string | n/a | yes |
| load_balancer_rule_name | Load balance address pool rule name | string | n/a | yes |
| load_balancer_sku | The SKU of the Azure load Balancer. Accepted values are Basic and Standard. | string | n/a | yes |
| Location | Location to create the Azure resources in - should be the region name of your subscription, e.g 'northeurope' | string | n/a | yes |
| network_interface_name | Network Interface name | string | n/a | yes |
| os_upgrade_mode | Specifies how Upgrades (e.g. changing the Image/SKU) should be performed to Virtual Machine Instances. Possible values are Automatic, Manual and Rolling. Defaults to Automatic | string | n/a | yes |
| resource_group_name | Name of the resource group to create and place your resources in | string | n/a | yes |
| tags | Optional map of strings to be used as Azure Tags for all resources. | map(string) | string | n/a | yes |
| xyz_subnet_name | Subnet name, found in the pre-existing virtual network in your subscription.| string | n/a | yes |
| xyz_vnet_name | XYZ virtual network name, found in your subscription | string | n/a | yes |
| xyz_vnet_rg_name | Existing resource group found in your subscription | string | n/a | yes |
| user_assigned_identities | Map of UAMI names and resource groups. | map(object({uami_name = string uami_rg_name = string})) | null | no |
| Virtual_machine_size | The Virtual Machine SKU for the Scale Set, Default is Standard_DS3_v2 | string | n/a | yes |
| vm_name_suffix | 2 digit or characters code used as appliction discretionary | string | ``"X2"``| no |
| vm_password_key_vault_name | Name of Keyvault where Password are stored | string | n/a | yes |
| vm_password_key_vault_resource_group | Name of resource group where the VM Password Key vault is created | string | n/a | yes |
| vm_scale_set_name | Name of Virtual Machine Scale Set | string | n/a | yes |





