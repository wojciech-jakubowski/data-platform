output "output" {
  value = {
    log_analytics_workspace_id     = azurerm_log_analytics_workspace.lgw.id
    app_insights_id                = azurerm_application_insights.ai.id
    app_insights_key               = azurerm_application_insights.ai.instrumentation_key
    app_insights_connection_string = azurerm_application_insights.ai.connection_string
  }
}