output "storage_account_id" {
  value       = azurerm_storage_account.secure_blob.id
  description = "Resource ID of the secure storage account."
}

output "primary_blob_endpoint" {
  value       = azurerm_storage_account.secure_blob.primary_blob_endpoint
  description = "Primary blob endpoint."
}
