resource "azurerm_key_vault_secret" "sample_secret" {
  name         = "sample-secret"
  value        = "szechuan"
  key_vault_id = var.key_vault.key_vault_id
  tags         = var.config.tags
}