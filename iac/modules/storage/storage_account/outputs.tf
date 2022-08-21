output "output" {
  value = {
    storage_account_id = azurerm_storage_account.sa.id
    account_key        = azurerm_storage_account.sa.primary_access_key
    connection_string  = azurerm_storage_account.sa.primary_connection_string
  }
}