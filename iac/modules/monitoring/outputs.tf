output "output" {
  value = {
    log_analytics_workspace_id     = azurerm_log_analytics_workspace.lgw.id
    app_insights_id                = azurerm_application_insights.ai.id
    app_insights_key               = azurerm_application_insights.ai.instrumentation_key
    app_insights_connection_string = azurerm_application_insights.ai.connection_string
    x = 2

    private_endpoints_config = [
      {
        resource_id   = azurerm_monitor_private_link_scope.pes.id
        endpoint_type = "azuremonitor"
        private_dns_zones = [
          var.networking.private_dns_zones.mon,
          var.networking.private_dns_zones.ods,
          var.networking.private_dns_zones.oms,
          var.networking.private_dns_zones.asc,
        ]
      }
    ]
  }
}