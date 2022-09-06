output "output" {
  value = {
    account = {
      id    = azurerm_purview_account.purview.id
      name  = azurerm_purview_account.purview.name
      mi_id = azurerm_purview_account.purview.identity[0].principal_id
    }
  }
}