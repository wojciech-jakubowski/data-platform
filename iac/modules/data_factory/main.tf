resource "azurerm_data_factory" "data_factory" {
  name                            = "${var.config.name_prefix}-adf"
  location                        = var.config.location
  resource_group_name             = var.config.resource_group_name
  managed_virtual_network_enabled = true
  public_network_enabled          = false

  global_parameter {
    name  = "env"
    type  = "String"
    value = var.config.env
  }
  global_parameter {
    name  = "client_name"
    type  = "String"
    value = var.config.client_name
  }
  global_parameter {
    name  = "project_name"
    type  = "String"
    value = var.config.project_name
  }

  identity {
    type = "SystemAssigned"
  }
}

module "diagnostic_settings" {
  source                         = "../monitoring/diagnostic_settings"
  config                         = var.config
  target_resource_id             = azurerm_data_factory.data_factory.id
  target_resource_name           = azurerm_data_factory.data_factory.name
  log_analytics_workspace_id     = var.monitoring.log_analytics_workspace.id
  log_analytics_destination_type = "Dedicated"
  logs = {
    "ActivityRuns"                        = true
    "PipelineRuns"                        = true
    "SandboxActivityRuns"                 = true
    "SandboxPipelineRuns"                 = true
    "TriggerRuns"                         = true
    "SSISIntegrationRuntimeLogs"          = false
    "SSISPackageEventMessageContext"      = false
    "SSISPackageEventMessages"            = false
    "SSISPackageExecutableStatistics"     = false
    "SSISPackageExecutionComponentPhases" = false
    "SSISPackageExecutionDataStatistics"  = false
  }
  metrics = {
    "AllMetrics" = true
  }
}