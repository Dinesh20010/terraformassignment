module "tagging" {
  source = ""
  version = "1.0.0"
  only_mandatory_tags =false
  resource_group_name = var.resource_group_name
}

locals {
  vmss_prefix = substr(lower(join("",
  ["x",
    substr(var.tags["opEnvironment"], 0, 1),
    substr(var.tags["opEnvironment"], 2, -1),
    var.vm_name_suffix
  ])), 0, 9)

  telemetry_tags = {
    TELEMETRY_TAG_KEY = "TELEMETRY_TAG_VALUES"
  }
  tags = merge(var.tags, local.telemetry_tags)
}

data "azurerm_subnet" "app_subnet" {
  name                 = var.app_subnet_name
  resource_group_name  = var.xyz_vnet_name
  virtual_network_name = var.xyz_net_resource_group_name
}

data "azurerm_disk_encryption_set" "disk_encryption_set" {
  name                = var.disk_encryption_set_name
  resource_group_name = var.disk_encryption_set_rg_name
}

data "azurerm_user_assigned_identity" "uami_list" {
  for_each            = try(var.user_assigned_identities, null) != null ? var.user_assigned_identities : {}
  name                = each.value.uami_name
  resource_group_name = each.value.uami_rg_name
}

data "azurerm_key_vault" "key_vault" {
  name                = var.vm_password_key_vault_name
  key_vault_id        = var.vm_password_key_vault_resource_group
}

resource "random_string" "random" {
  length = 3
  special = false
}

resource "random_password" "password" {
  length = 16
  special = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault_secret" "vmss_password" {
  name         = ("Linux-Server-Password-${random_string.random.result}")
  value        = random_password.password.result
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = var.vm_scale_set_name
  resource_group_name = var.resource_group_name
  location            = var.location
  instances           = var.instances
  sku                 = var.virtual_machine_size
  upgrade_mode        = var.os_upgrade_mode

  computer_name_prefix = local.vmss_prefix
  disable_password_authentication = false
  admin_username      = localadmin
  admin_password      = azurerm_key_vault_secret.vmss_password.value

  source_image_reference {
    offer     = "Redhat"
    publisher = "rhel"
    sku       = "rhel-lvm79"
    version   = "latest"
  }

  plan {
    name      = "rhel-lvm79"
    product   = "redhat"
    publisher = "rhel"
  }

  os_disk {
    caching              = var.disk_caching
    storage_account_type = var.disk_type
    disk_encryption_set_id = data.azurerm_disk_encryption_set.disk_encryption_set.id
  }

  data_disk {
    caching              = var.disk_caching
    create_option        = var.disk_option
    disk_size_gb         = var.disk_size_gb
    lun                  = 0
    storage_account_type = var.disk_type

    disk_encryption_set_id = data.azurerm_disk_encryption_set.disk_encryption_set.id
  }

  network_interface {
    name = var.network_interface_name
    primary = true

    ip_configuration {
      name = var.ip_configuration_name
      primary = true
      subnet_id = data.azurerm_subnet.app_subnet.id
      load_balancer_backend_address_pool_ids = []
    }
  }

  identity {
    type = (try(length(data.azurerm_user_assigned_identity.uami_list), null == null || try(length(data.azurerm_user_assigned_identity.uami_list), 0) == 0) ? "SystemAssigned" : "UserAssigned"
    identity_ids = (try(length(data.azurerm_user_assigned_identity.uami_list), {}) == {} || try(length(data.azurerm_user_assigned_identity.uami_list), 0) == 0) ? [] : values(data.azurerm_user_assigned_identity.uami_list)[*].id
  }
}

 resource "azurerm_virtual_machine_scale_set_extension" "setup_vmss" {
   count = var.bootstrap_script != "" ? 1:0
   name                         = var.extension_name
   virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.vmss.id
   publisher                    = var.extension_publisher
   type                         = var.extension_type
   type_handler_version         = var.extension_version
   auto_upgrade_minor_version   = true
   protected_settings           = <<SETTINGS
   {
      "script": "${base64encode(templatefile(var.bootstrap_script, var.bootstrap_params))}"
    }
    SETTINGS
 }

  resource "azurerm_lb_probe" "vmss" {
    loadbalancer_id = azurerm_lb.vmss.id
    name            = var.azurerm_probe_name
    port            = var.azurerm_probe_port
  }

 resource "azurerm_lb" "vmss" {
   name                = var.load_balancer_name
   location            = var.location
   resource_group_name = var.resource_group_name
   sku                 = var.load_balancer_sku
   tags                = local.tags

   frontend_ip_configuration {
     name = var.frontend_configuration_name
     subnet_id = data.azurerm_subnet.app_subnet.id
     private_ip_address_allocation = var.configuration_allocation
   }
 }

 resource "azurerm_lb_backend_address_pool" "vmss" {
   loadbalancer_id = azurerm_lb.vmss.id
   name            = var.backend_address_pool_name
 }

 resource "azurerm_lb_rule" "vmss" {
   name                           = var.load_balancer_rule_name
   loadbalancer_id                = azurerm_lb.vmss.id
   probe_id                       = azurerm_lb_probe.vmss.id
   protocol                       = var.load_balancer_protocol
   frontend_port                  = var.load_balancer_frontend_port
   backend_port                   = var.load_balancer_backend_port
   frontend_ip_configuration_name = azurerm_lb.vmss.frontend_ip_configuration[0].name
 }


