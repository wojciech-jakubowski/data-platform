resource "azurerm_databricks_workspace" "workspace" {
  name                          = "${var.config.name_prefix}-dbw"
  resource_group_name           = var.config.resource_group_name
  location                      = var.config.location
  sku                           = "premium"
  managed_resource_group_name   = "${var.config.name_prefix}-dbw-rg"
  public_network_access_enabled = true
  network_security_group_rules_required = var.networking != null ? "NoAzureDatabricksRules " : null

  custom_parameters {
    no_public_ip        = true
    virtual_network_id  = var.networking != null ? var.networking.vnet.id : null
    vnet_address_prefix = var.networking != null ? var.networking.vnet.address_prefix : null
    public_subnet_name  = var.networking != null ? var.networking.vnet.db_public_subnet.name : null
    private_subnet_name = var.networking != null ? var.networking.vnet.db_private_subnet.name : null

    storage_account_name     = "${var.config.dashless_name_prefix}dbssa"
    storage_account_sku_name = "Standard_GRS"
  }

  tags = var.config.tags
}

module "diagnostic_settings" {
  source                     = "../monitoring/diagnostic_settings"
  config                     = var.config
  target_resource_id         = azurerm_databricks_workspace.workspace.id
  target_resource_name       = azurerm_databricks_workspace.workspace.name
  log_analytics_workspace_id = var.monitoring.log_analytics_workspace.id
  logs = {
    "accounts"             = true
    "clusters"             = true
    "databrickssql"        = true
    "dbfs"                 = true
    "deltaPipelines"       = true
    "featureStore"         = true
    "genie"                = true
    "globalInitScripts"    = true
    "iamRole"              = true
    "instancePools"        = true
    "jobs"                 = true
    "mlflowAcledArtifact"  = true
    "mlflowExperiment"     = true
    "modelRegistry"        = true
    "notebook"             = true
    "RemoteHistoryService" = true
    "repos"                = true
    "secrets"              = true
    "sqlanalytics"         = true
    "sqlPermissions"       = true
    "ssh"                  = true
    "unityCatalog"         = true
    "workspace"            = true
  }
  metrics = {}
}