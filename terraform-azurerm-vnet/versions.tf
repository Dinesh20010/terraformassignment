terraform {
  required_version = ">= 0.14"

  required_providers {
    azurerm = ">= 2.0"
  }
}

provider "azurerm" {
  features {}
}
