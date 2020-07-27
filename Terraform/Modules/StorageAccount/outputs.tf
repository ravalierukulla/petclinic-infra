output "id" {
  description = "Id of the storage account created."
  value       = "${azurerm_storage_account.storage.id}"
}

output "account_name" {
  description = "Name of the storage account created."
  value       = "${azurerm_storage_account.storage.name}"
}

output "primary_connection_string" {
  value = "${azurerm_storage_account.storage.primary_connection_string}"
}
