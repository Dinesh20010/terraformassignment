variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region location"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "app_subnet_name" {
  description = "Name of the application-tier subnet"
  type        = string
}

variable "db_subnet_name" {
  description = "Name of the database-tier subnet"
  type        = string
}

variable "app_nsg_name" {
  description = "Name of the application-tier network security group"
  type        = string
}

variable "db_nsg_name" {
  description = "Name of the database-tier network security group"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "app_subnet_cidr" {
  description = "CIDR block for the application-tier subnet"
  type        = string
}

variable "db_subnet_cidr" {
  description = "CIDR block for the database-tier subnet"
  type        = string
}

variable "app_nsg_ports" {
  description = "Ports to allow in the application-tier network security group"
  type        = list(number)
  default     = [8080, 80, 443]
}

variable "db_nsg_ports" {
  description = "Ports to allow in the database-tier network security group"
  type        = list(number)
  default     = [3306, 1433, 5432]
}