output "storage_account" {
  value = {
    id                = azurerm_storage_account.sa.id
    name              = azurerm_storage_account.sa.name
    key               = azurerm_storage_account.sa.primary_access_key
    connection_string = azurerm_storage_account.sa.primary_connection_string
    is_hns_enabled    = azurerm_storage_account.sa.is_hns_enabled
  }
}