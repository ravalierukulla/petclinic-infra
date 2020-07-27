output name {
  value       = azurerm_resource_group.rg.name
  description = "Resource Gorup Name"
}

output location {
  description = "Resource Gorup Location"
  value       = azurerm_resource_group.rg.location
}