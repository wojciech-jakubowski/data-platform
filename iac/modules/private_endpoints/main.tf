# key_vault
module "kv_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = var.networking.main_subnet.id
  parent_resource_id   = var.key_vault.vault.id
  parent_resource_name = var.key_vault.vault.name
  endpoint_type        = "vault"
  private_dns_zones    = [var.networking.private_dns_zones.kv]
}

# monitoring
module "private_endpoint_scope" {
  source                     = "./private_endpoint_scope"
  config                     = var.config
  log_analytics_workspace_id = var.monitoring.log_analytics.id
  app_insights_id            = var.monitoring.app_insights.id
}

module "pes_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = var.networking.main_subnet.id
  parent_resource_id   = module.private_endpoint_scope.scope.id
  parent_resource_name = module.private_endpoint_scope.scope.name
  endpoint_type        = "azuremonitor"
  private_dns_zones = [
    var.networking.private_dns_zones.mon,
    var.networking.private_dns_zones.ods,
    var.networking.private_dns_zones.oms,
    var.networking.private_dns_zones.asc
  ]
}

# storage
module "sa_dl_blob_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = var.networking.main_subnet.id
  parent_resource_id   = var.storage.data_lake.id
  parent_resource_name = var.storage.data_lake.name
  name_suffix          = "blob"
  endpoint_type        = "blob"
  private_dns_zones    = [var.networking.private_dns_zones.blob]
}

module "sa_dl_dfs_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = var.networking.main_subnet.id
  parent_resource_id   = var.storage.data_lake.id
  parent_resource_name = var.storage.data_lake.name
  name_suffix          = "dfs"
  endpoint_type        = "dfs"
  private_dns_zones    = [var.networking.private_dns_zones.dfs]
  count                = var.storage.data_lake.is_hns_enabled ? 1 : 0
}

module "synapse_dev_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = var.networking.main_subnet.id
  parent_resource_id   = var.synapse.workspace.id
  parent_resource_name = var.synapse.workspace.name
  name_suffix          = "dev"
  endpoint_type        = "Dev"
  private_dns_zones    = [var.networking.private_dns_zones.syn_dev]
  count                = var.synapse != null ? 1 : 0
}

module "synapse_sql_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = var.networking.main_subnet.id
  parent_resource_id   = var.synapse.workspace.id
  parent_resource_name = var.synapse.workspace.name
  name_suffix          = "sql"
  endpoint_type        = "Sql"
  private_dns_zones    = [var.networking.private_dns_zones.syn_sql]
  count                = var.synapse != null ? 1 : 0
}

module "synapse_sql_on_demand_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = var.networking.main_subnet.id
  parent_resource_id   = var.synapse.workspace.id
  parent_resource_name = var.synapse.workspace.name
  name_suffix          = "sod"
  endpoint_type        = "SqlOnDemand"
  private_dns_zones    = [var.networking.private_dns_zones.syn_sql]
  count                = var.synapse != null ? 1 : 0
}

module "synapse_private_link_hub" {
  source              = "./private_link_hub"
  config              = var.config
  subnet_id           = var.networking.main_subnet.id
  private_dns_zone_id = var.networking.private_dns_zones.syn
  count               = var.synapse != null ? 1 : 0
}

module "purview_portal_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = var.networking.main_subnet.id
  parent_resource_id   = var.purview.account.id
  parent_resource_name = var.purview.account.name
  name_suffix          = "ptl"
  endpoint_type        = "portal"
  private_dns_zones    = [var.networking.private_dns_zones.pur_por]
  count                = var.purview != null ? 1 : 0
}

module "purview_account_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = var.networking.main_subnet.id
  parent_resource_id   = var.purview.account.id
  parent_resource_name = var.purview.account.name
  name_suffix          = "acc"
  endpoint_type        = "account"
  private_dns_zones    = [var.networking.private_dns_zones.pur_acc]
  count                = var.purview != null ? 1 : 0
}