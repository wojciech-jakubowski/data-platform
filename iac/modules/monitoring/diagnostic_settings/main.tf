resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  name                       = "${var.target_resource_name}-diagnostic-settings"
  target_resource_id         = var.target_resource_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "log" {
    for_each = var.logs
    content {
      category = log.key
      enabled  = log.value
      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }

  dynamic "metric" {
    for_each = var.metrics
    content {
      category = metric.key
      enabled  = metric.value
      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }
}