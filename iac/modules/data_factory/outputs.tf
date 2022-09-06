output "output" {
  value = {
    factory = {
      id    = azurerm_data_factory.data_factory.id
      name  = azurerm_data_factory.data_factory.name
      mi_id = azurerm_data_factory.data_factory.identity[0].principal_id
    }
  }
}