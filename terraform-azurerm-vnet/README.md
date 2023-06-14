# Azure Virtual Network Module

This Terraform module creates an Azure Virtual Network with an application-tier subnet and network security group, as well as a database-tier subnet and network security group. It provides a reusable and modular way to set up network isolation within the Azure ecosystem.

## Features

- Creates an Azure Virtual Network with specified address space.
- Sets up an application-tier subnet with customizable CIDR block.
- Configures a network security group for the application-tier subnet, allowing ports 8080, 80, and 443.
- Creates a database-tier subnet with customizable CIDR block.
- Configures a network security group for the database-tier subnet, allowing ports 3306, 1433, and 5432.

## Usage

```hcl
module "azure_virtual_network" {
  source              = "./terraform-azurerm-vnet"
  resource_group_name = "my-resource-group"
  location            = "eastus"
  vnet_name           = "my-vnet"
  app_subnet_name     = "app-subnet"
  db_subnet_name      = "db-subnet"
  app_nsg_name        = "app-nsg"
  db_nsg_name         = "db-nsg"
  address_space       = ["10.0.0.0/16"]
  app_subnet_cidr     = "10.0.1.0/24"
  db_subnet_cidr      = "10.0.2.0/24"
}
```
# Inputs

| Name         | Description  | Type      | Default   | Required   |
|--------------|--------------|-----------|-----------|------------|
|resource_group_name |	Name of the resource group	| string	|	Yes |
|location	|Azure region location	|string	|	Yes |
|vnet_name |	Name of the virtual network |	string | Yes|
|app_subnet_name	|Name of the application-tier subnet	| string	|	Yes|
|db_subnet_name|	Name of the database-tier subnet |	string	|	Yes|
| app_nsg_name |	Name of the application-tier NSG |	string	|	Yes|
|db_nsg_name |	Name of the database-tier NSG |	string |		Yes |
|address_space |	Address space for the virtual network	|list(string)|		Yes|
|app_subnet_cidr | CIDR block for the application-tier subnet	| string |	Yes|
|db_subnet_cidr	| CIDR block for the database-tier subnet	| string|		Yes|
|app_nsg_ports	| Ports to allow in the application-tier NSG |	list(number) |	[8080, 80, 443] |	No |
|db_nsg_ports |	Ports to allow in the database-tier NSG |	list(number) |	[3306, 1433, 5432] |	No |

# Outputs

| Name | Description |
|-----------------|-----------------|
|vnet_id	|ID of the virtual network|
|app_subnet_id |	ID of the application-tier subnet |
|db_subnet_id	|ID of the database-tier subnet|
|app_nsg_id	| ID of the application-tier NSG|
| db_nsg_id |	ID of the database-tier NSG |

