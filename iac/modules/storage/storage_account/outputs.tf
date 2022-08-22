output "storage_account" {
  value = {
    id                = azurerm_storage_account.sa.id
    name              = azurerm_storage_account.sa.name
    key               = azurerm_storage_account.sa.primary_access_key
    connection_string = azurerm_storage_account.sa.primary_connection_string
    is_hns_enabled    = azurerm_storage_account.sa.is_hns_enabled
    blob_endpoint     = azurerm_storage_account.sa.primary_blob_endpoint
    dfs_endpoint      = azurerm_storage_account.sa.primary_dfs_endpoint
    containers        = { for k, v in azurerm_storage_container.container : k => v.id }
  }
}