terraform {
  required_version = "=0.12.28"

    backend "azurerm" {
    }
}

# Configure the Azure Provider
provider "azurerm" {
  version = "=1.44.0"
}