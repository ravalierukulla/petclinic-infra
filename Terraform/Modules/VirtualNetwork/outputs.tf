output "name" {
  value = "${azurerm_virtual_network.vnet.name}"
}

output "vnet_subnets" {
  value = "${azurerm_subnet.subnets.*}"
}