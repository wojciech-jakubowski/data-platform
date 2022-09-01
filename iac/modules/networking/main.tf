# DNS zones
module "private_dns_zones" {
  source = "./private_dns_zones"
  config = var.config
}

# vnet
module "network" {
  source = "./network"
  config = var.config
}

#db nsg
module "db_nsg" {
  source = "./network_security_group"
  config = var.config
  name   = "db"
  count  = var.databricks != null ? 1 : 0
}

# key_vault
module "kv_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = module.network.vnet.main_subnet.id
  parent_resource_id   = var.key_vault.key_vault.id
  parent_resource_name = var.key_vault.key_vault.name
  endpoint_type        = "vault"
  private_dns_zones    = [module.private_dns_zones.zones.kv]
}

# monitoring
module "private_endpoint_scope" {
  source                     = "./private_endpoint_scope"
  config                     = var.config
  log_analytics_workspace_id = var.monitoring.log_analytics_workspace.id
  app_insights_id            = var.monitoring.app_insights.id
}

module "pes_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = module.network.vnet.main_subnet.id
  parent_resource_id   = module.private_endpoint_scope.scope.id
  parent_resource_name = module.private_endpoint_scope.scope.name
  endpoint_type        = "azuremonitor"
  private_dns_zones = [
    module.private_dns_zones.zones.mon,
    module.private_dns_zones.zones.ods,
    module.private_dns_zones.zones.oms,
    module.private_dns_zones.zones.asc
  ]
}

# storage
module "sa_dl_blob_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = module.network.vnet.main_subnet.id
  parent_resource_id   = var.storage.dl.id
  parent_resource_name = var.storage.dl.name
  name_suffix          = "blob"
  endpoint_type        = "blob"
  private_dns_zones    = [module.private_dns_zones.zones.blob]
}

module "sa_dl_dfs_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = module.network.vnet.main_subnet.id
  parent_resource_id   = var.storage.dl.id
  parent_resource_name = var.storage.dl.name
  name_suffix          = "dfs"
  endpoint_type        = "dfs"
  private_dns_zones    = [module.private_dns_zones.zones.dfs]
  count                = var.storage.dl.is_hns_enabled ? 1 : 0
}

module "synapse_dev_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = module.network.vnet.main_subnet.id
  parent_resource_id   = var.synapse.workspace.id
  parent_resource_name = var.synapse.workspace.name
  name_suffix          = "dev"
  endpoint_type        = "Dev"
  private_dns_zones    = [module.private_dns_zones.zones.syn_dev]
  count                = var.synapse != null ? 1 : 0
}

module "synapse_sql_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = module.network.vnet.main_subnet.id
  parent_resource_id   = var.synapse.workspace.id
  parent_resource_name = var.synapse.workspace.name
  name_suffix          = "sql"
  endpoint_type        = "Sql"
  private_dns_zones    = [module.private_dns_zones.zones.syn_sql]
  count                = var.synapse != null ? 1 : 0
}

module "synapse_sql_on_demand_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = module.network.vnet.main_subnet.id
  parent_resource_id   = var.synapse.workspace.id
  parent_resource_name = var.synapse.workspace.name
  name_suffix          = "sod"
  endpoint_type        = "SqlOnDemand"
  private_dns_zones    = [module.private_dns_zones.zones.syn_sql]
  count                = var.synapse != null ? 1 : 0
}

module "synapse_private_link_hub" {
  source              = "./private_link_hub"
  config              = var.config
  subnet_id           = module.network.vnet.main_subnet.id
  private_dns_zone_id = module.private_dns_zones.zones.syn
  count               = var.synapse != null ? 1 : 0
}

module "purview_portal_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = module.network.vnet.main_subnet.id
  parent_resource_id   = var.purview.purview.id
  parent_resource_name = var.purview.purview.name
  name_suffix          = "ptl"
  endpoint_type        = "portal"
  private_dns_zones    = [module.private_dns_zones.zones.pur_por]
  count                = var.purview != null ? 1 : 0
}

module "purview_account_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = module.network.vnet.main_subnet.id
  parent_resource_id   = var.purview.purview.id
  parent_resource_name = var.purview.purview.name
  name_suffix          = "acc"
  endpoint_type        = "account"
  private_dns_zones    = [module.private_dns_zones.zones.pur_acc]
  count                = var.purview != null ? 1 : 0
}