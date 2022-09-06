resource "azurerm_monitor_private_link_scope" "pes" {
  name                = "${var.config.name_prefix}-pes"
  resource_group_name = var.config.resource_group_name
  tags                = var.config.tags
}

resource "azurerm_monitor_private_link_scoped_service" "pes_lwg_service" {
  name                = "${var.config.name_prefix}-pes-lgw"
  resource_group_name = var.config.resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.pes.name
  linked_resource_id  = var.log_analytics_workspace_id
}

resource "azurerm_monitor_private_link_scoped_service" "pes_ai_service" {
  name                = "${var.config.name_prefix}-pes-ai"
  resource_group_name = var.config.resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.pes.name
  linked_resource_id  = var.app_insights_id
}