resource "azurerm_log_analytics_workspace" "lgw" {
  name                = "${var.config.name_prefix}-lgw"
  location            = var.config.location
  resource_group_name = var.config.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 180
  tags                = var.config.tags
}

resource "azurerm_application_insights" "ai" {
  name                = "${var.config.name_prefix}-lgw"
  location            = var.config.location
  resource_group_name = var.config.resource_group_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.lgw.id
  tags                = var.config.tags
}