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
  log_analytics_workspace_id = var.monitoring.log_analytics_workspace.id
  logs = {
    "DataSensitivityLogEvent" = true
    "ScanStatusLogEvent"      = true
    "Security"                = true
  }
  metrics = {
    "AllMetrics" = true
  }
}