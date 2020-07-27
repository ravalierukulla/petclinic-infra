data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

module "resource_group" {
  source = "./../Terraform/Modules/ResourceGroup"

  name                          = local.rg_name
  tags                          = local.tags
  location                      = var.location
}

module "virtual_network" {
  source = "./../Terraform/Modules/VirtualNetwork"

  name                         = local.vnet_name
  tags                          = local.tags
  resource_group_name           = module.resource_group.name
  location                      = var.location
  vnet_cidr                     = var.vnet_cidr

  subnets                       = var.subnets
}