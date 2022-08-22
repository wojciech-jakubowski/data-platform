resource "azurerm_log_analytics_workspace" "lgw" {
  name                       = "${var.config.name_prefix}-lgw"
  location                   = var.config.location
  resource_group_name        = var.config.resource_group_name
  sku                        = "PerGB2018"
  retention_in_days          = 180
  tags                       = var.config.tags
  internet_ingestion_enabled = !var.config.deploy_networking
}

resource "azurerm_application_insights" "ai" {
  name                       = "${var.config.name_prefix}-lgw"
  location                   = var.config.location
  resource_group_name        = var.config.resource_group_name
  application_type           = "web"
  workspace_id               = azurerm_log_analytics_workspace.lgw.id
  tags                       = var.config.tags
  internet_ingestion_enabled = !var.config.deploy_networking
}

module "kv_diagnostic_settings" {
  source                     = "./diagnostic_settings"
  config                     = var.config
  target_resource_id         = var.key_vault.key_vault.id
  target_resource_name       = var.key_vault.key_vault.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lgw.id
  logs = {
    "AuditEvent"                   = true
    "AzurePolicyEvaluationDetails" = true
  }
  metrics = {
    "AllMetrics" = true
  }
}

module "sa_dl_diagnostic_settings" {
  source                     = "./diagnostic_settings"
  config                     = var.config
  target_resource_id         = "${var.storage.dl_storage_account.id}/blobServices/default"
  target_resource_name       = var.storage.dl_storage_account.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lgw.id
  logs = {
    "StorageRead"   = true
    "StorageWrite"  = true
    "StorageDelete" = true
  }
  metrics = {
    "Capacity"    = true
    "Transaction" = true
  }
}

module "synapse_diagnostic_settings" {
  source                     = "./diagnostic_settings"
  config                     = var.config
  target_resource_id         = var.synapse.workspace_id
  target_resource_name       = var.synapse.workspace_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lgw.id
  logs = {
    "BuiltinSqlReqsEnded"     = true
    "GatewayApiRequests"      = true
    "IntegrationActivityRuns" = true
    "IntegrationPipelineRuns" = true
    "IntegrationTriggerRuns"  = true
    "SynapseRbacOperations"   = true
  }
  metrics = {}
}