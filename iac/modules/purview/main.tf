resource "azurerm_purview_account" "purview" {
  name                        = "${var.config.name_prefix}-prv"
  resource_group_name         = var.config.resource_group_name
  managed_resource_group_name = "${var.config.client_name}-${var.config.project_name}-${var.config.env}-prv-rg"
  location                    = var.config.location
  public_network_enabled      = true

  identity {
    type = "SystemAssigned"
  }
}


module "diagnostic_settings" {
  source                     = "../monitoring/diagnostic_settings"
  config                     = var.config
  target_resource_id         = azurerm_purview_account.purview.id
  target_resource_name       = azurerm_purview_account.purview.name
  log_analytics_workspace_id = var.monitoring.log_analytics.id
  logs = {
    "DataSensitivityLogEvent" = true
    "ScanStatusLogEvent"      = true
    "Security"                = true
  }
  metrics = {
    "AllMetrics" = true
  }
}

resource "azurerm_key_vault_access_policy" "purview_on_kv" {
  key_vault_id       = var.key_vault.vault.id
  tenant_id          = var.config.tenant_id
  object_id          = azurerm_purview_account.purview.identity[0].principal_id
  secret_permissions = ["Get", "List"]
}