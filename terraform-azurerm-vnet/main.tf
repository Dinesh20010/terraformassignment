locals {
  app_nsg_ports = [8080, 80, 443]
  db_nsg_ports  = [3306, 1433, 5432]
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
}

resource "azurerm_subnet" "app_subnet" {
  name                 = var.app_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.app_subnet_cidr]
}

resource "azurerm_subnet" "db_subnet" {
  name                 = var.db_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.db_subnet_cidr]
}

resource "azurerm_network_security_group" "app_nsg" {
  name                = var.app_nsg_name
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.app_nsg_ports
    content {
      name                       = "AllowPort${security_rule.value}"
      priority                   = 100 + security_rule.index
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_network_security_group" "db_nsg" {
  name                = var.db_nsg_name
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.db_nsg_ports
    content {
      name                       = "AllowPort${security_rule.value}"
      priority                   = 100 + security_rule.index
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}