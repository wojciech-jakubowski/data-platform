output "output" {
  value = {
    vault = {
      id   = azurerm_key_vault.key_vault.id
      name = azurerm_key_vault.key_vault.name
    }
  }
}