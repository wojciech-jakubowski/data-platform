locals {
  secrets = merge(var.monitoring.app_insights.secrets, var.storage.dl_storage_account.secrets)
}

resource "azurerm_key_vault_secret" "secrets" {
  for_each     = local.secrets
  name         = each.key
  value        = each.value
  key_vault_id = var.key_vault.key_vault_id
}
