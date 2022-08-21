resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  name                       = var.target_resource_name
  target_resource_id         = var.target_resource_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    for_each = var.logs
    category = each.key
    enabled  = each.value.enabled

    retention_policy {
      enabled = each.value.retention_policy_enabled
      days    = each.value.retention_policy_days
    }
  }

  #   metric {
  #     category = "AllMetrics"

  #     retention_policy {
  #       enabled = false
  #     }
  #   }
}