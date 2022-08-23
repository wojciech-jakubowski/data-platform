output "output" {
  value = {
    adf = {
      id   = azurerm_data_factory.data_factory.id
      name = azurerm_data_factory.data_factory.name
    }
  }
}