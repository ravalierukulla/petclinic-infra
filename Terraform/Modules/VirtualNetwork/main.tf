data "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
}

locals {
  resource_location = var.location != "" ? var.location : data.azurerm_resource_group.rg.location

  map_nsgIds = { for key, value in azurerm_network_security_group.main : "${key}" => value.id }

   mandatory_tags = {
    env = lower(var.Environment)
  }

  tags = merge(local.mandatory_tags, var.tags)
}

# Create VNet
resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = local.resource_location
  tags                = local.tags

  address_space       = [var.vnet_cidr]
  dns_servers         = length(var.vnet_dns_servers) > 0 ? var.vnet_dns_servers : null
}

# Create Subnets
resource "azurerm_subnet" "subnets" {
  for_each                                       = var.subnets
  name                                           = each.value.name
  resource_group_name                            = data.azurerm_resource_group.rg.name
  address_prefix                                 = each.value.address_prefix

  virtual_network_name                           = azurerm_virtual_network.vnet.name
  service_endpoints                              = lookup(each.value, "pe_enable", false) == false ? lookup(each.value, "service_endpoints", []) : null
  enforce_private_link_endpoint_network_policies = lookup(each.value, "pe_enable", false)
  enforce_private_link_service_network_policies  = lookup(each.value, "pe_enable", false)
  network_security_group_id = each.value.nsg_name != "" ? lookup(local.map_nsgIds, each.value.nsg_name) : null

  lifecycle {
    ignore_changes = [
      enforce_private_link_service_network_policies,
      enforce_private_link_endpoint_network_policies
    ]
  }
}
