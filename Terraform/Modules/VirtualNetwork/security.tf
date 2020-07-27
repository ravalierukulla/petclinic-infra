resource "azurerm_network_security_group" "main" {
  for_each = var.nsgs
  name                = each.key
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = [for r in each.value.rules : {
      name                       = r.name
      priority                   = r.priority
      direction                  = r.direction
      access                     = r.access
      protocol                   = r.protocol
      source_port_range          = r.source_port_range
      destination_port_range     = r.destination_port_range
      source_address_prefix      = r.source_address_prefix
      destination_address_prefix = r.destination_address_prefix
    }]

    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}