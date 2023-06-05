variable "tags" {
  description = "Name of the resource group where the Azure Keyvault resides."
  type = map(string)
  default = {}
}

variable "xyz_net_resource_group_name" {
  description = "Resouce group containing the xyz networking resources"
  type = string
}

variable "xyz_vnet_name" {
  description = "xyz virtual network name"
  type = string
}

variable "app_subnet_name" {
  description = "xyz subnet name"
  type = string
}

variable "location" {
  description = "location to crate Azure resources"
  type = string
}

variable "resource_group_name" {
  description = "Name of the resource group to create and place your resources in."
  type = string
}

variable "vm_scale_set_name" {
  description = "name of virtual machine scale set"
  type = string
}

variable "vm_name_suffix" {
  description = "2 digit or characters code used as application discretionary"
  type = string
  default = "x2"
  validation {
    condition = (
       length(var.vm_name_suffix) == 2 &&
       can(regex("[0-9A-Za-z]{2}", var.vm_name_suffix))
    )
    error_message = "Invalid vm_name_suffix Value."
  }
}

variable "instances" {
  description = "Number of Instances Initialy deployed withing scale set"
  type = number
}

variable "user_assigned_identities" {
  description = "Map of UAMI names and resource groups."
  type = map(object({
    uami_name = string
    uami_rg_name = string
  }))
  default = null
}

variable "bootstrap_script" {
  description = "Path to bootstrap script."
  type = string
}

variable "disk_encryption_set_name" {
  description = "disk encryption set name."
  type = string
}

variable "disk_encryption_set_rg_name" {
  description = "disk encryption set name resource group name."
  type = string
}

variable "virtual_machine_size" {
  description = "The Virtual machine SKU for the scale set, default Is Standard_DS3_v2"
  type = string
}

variable "os_upgrade_mode" {
  description = "Specifies how upgrades (e.g. changing the Image/SKU) Sshould be performed to virtual machine instances "
  type = string
}

variable "load_balancer_sku" {
  description = "The SKU of the Azure Load Balancer. Accepted Values are basic and Standard"
  type = string
}

variable "bootstrap_params" {
  description = "Bootstrap script Parameters."
  type = map(string)
  default = {}
}

variable "load_balancer_frontend_port" {
  description = "Port to be forwarded through the load balancer to the Vms"
  type = number
}

variable "load_balancer_backend_port" {
  description = "Linux Vm port to be connected via load balancer."
  type = number
}

variable "azurerm_probe_name" {
  description = "Azure Load balancer port probe name"
  type = string
}

variable "azurerm_probe_port" {
  description = "Azure probe port"
  type = string
}

variable "load_balancer_name" {
  description = "Azure Load balancer Name"
  type = string
}

variable "frontend_configuration_name" {
  description = "Load Balancer Frontend configuration name"
  type = string
}

variable "configuration_allocation" {
  description = "Private Ip Address configuration"
  type = string
}

variable "load_balancer_protocol" {
  description = "Loan Balancer protocol"
  type = string
}

variable "disk_caching" {
  description = "Data Disk Caching"
  default = string
}

variable "disk_type" {
  description = "storage account type"
  default = string
}

variable "disk_option" {
  description = "data disk option"
  default = string
}

variable "disk_size_gb" {
  description = "Data disk size gb"
  default = string
}

variable "network_interface_name" {
  description = "Network Interface name"
  default = string
}

variable "ip_configuration_name" {
  description = "Ip configuration name"
  default = string
}

variable "extension_name" {
  description = "scale set resources extension name"
  type = string
}

variable "extension_publisher" {
  description = "Scale set resources extension punlisher"
  type = string
}

variable "extension_type" {
  description = "scale set resources extension type"
  type = string
}

variable "extension_version" {
  description = "scale set resources extension type version"
  type = string
}

variable "backend_address_pool_name" {
  description = "load balance address pool name"
  type = string
}

variable "load_balancer_rule_name" {
  description = "Load balance address pool rule name"
  type = string
}

variable "vm_password_key_vault_name" {
  description = "Name of keyvault where password are stored"
  type = string
}

variable "vm_password_key_vault_resource_group" {
  description = "Name of resource group where the vm password key vault is created"
  type = string
}


