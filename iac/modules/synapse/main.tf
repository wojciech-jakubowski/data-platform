resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

locals {
  sql_admin_login = "${var.config.client_name}-sqladminuser"
}

resource "azurerm_synapse_workspace" "workspace" {
  name                                 = "${var.config.name_prefix}-sw"
  resource_group_name                  = var.config.resource_group_name
  managed_resource_group_name          = "${var.config.client_name}-${var.config.project_name}-${var.config.env}-sw-rg"
  location                             = var.config.location
  storage_data_lake_gen2_filesystem_id = "${var.storage.dl.dfs_endpoint}/synapse"
  sql_administrator_login              = local.sql_admin_login
  sql_administrator_login_password     = random_password.password.result
  managed_virtual_network_enabled      = true
  public_network_access_enabled        = true

  aad_admin {
    login     = var.config.synapse_aad_admin.login
    object_id = var.config.synapse_aad_admin.object_id
    tenant_id = var.config.tenant_id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.config.tags
}

resource "azurerm_synapse_firewall_rule" "allow_azure_services_rule" {
  name                 = "AllowAllWindowsAzureIps"
  synapse_workspace_id = azurerm_synapse_workspace.workspace.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "0.0.0.0"
}

resource "azurerm_synapse_firewall_rule" "deployer_rule" {
  name                 = "Deployer"
  synapse_workspace_id = azurerm_synapse_workspace.workspace.id
  start_ip_address     = var.config.deployer_ip_address
  end_ip_address       = var.config.deployer_ip_address
}

module "diagnostic_settings" {
  source                     = "../monitoring/diagnostic_settings"
  config                     = var.config
  target_resource_id         = azurerm_synapse_workspace.workspace.id
  target_resource_name       = azurerm_synapse_workspace.workspace.name
  log_analytics_workspace_id = var.monitoring.log_analytics_workspace.id
  logs = {
    "BuiltinSqlReqsEnded"     = true
    "GatewayApiRequests"      = true
    "IntegrationActivityRuns" = true
    "IntegrationPipelineRuns" = true
    "IntegrationTriggerRuns"  = true
    "SynapseRbacOperations"   = true
    "SynapseLinkEvent"        = true
    "SQLSecurityAuditEvents"  = true
  }
  metrics = {
    "AllMetrics" = true
  }
}
