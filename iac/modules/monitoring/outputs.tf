output "output" {
  value = {
    log_analytics_workspace = {
      id = azurerm_log_analytics_workspace.lgw.id
    }
    app_insights = {
      id = azurerm_application_insights.ai.id
    }
    secrets = {
      "AppInsightsKey"              = azurerm_application_insights.ai.instrumentation_key
      "AppInsightsConnectionString" = azurerm_application_insights.ai.connection_string
    }
  }
}