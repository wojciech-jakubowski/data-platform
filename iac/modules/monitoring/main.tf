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
}

resource "azurerm_monitor_private_link_scope" "pes" {
  name                = "${var.config.name_prefix}-pes"
  resource_group_name = var.config.resource_group_name
  tags                = var.config.tags
}

resource "azurerm_monitor_private_link_scoped_service" "pes_lwg_service" {
  name                = "${var.config.name_prefix}-pes-lgw"
  resource_group_name = var.config.resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.pes.name
  linked_resource_id  = azurerm_log_analytics_workspace.lgw.id
}

resource "azurerm_monitor_private_link_scoped_service" "pes_ai_service" {
  name                = "${var.config.name_prefix}-pes-ai"
  resource_group_name = var.config.resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.pes.name
  linked_resource_id  = azurerm_application_insights.ai.id
}