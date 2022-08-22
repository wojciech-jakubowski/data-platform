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
  parent_resource_id   = var.storage.dl_storage_account.id
  parent_resource_name = var.storage.dl_storage_account.name
  name_suffix          = "blob"
  endpoint_type        = "blob"
  private_dns_zones    = [module.private_dns_zones.zones.blob]
}

module "sa_dl_dfs_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id            = module.network.vnet.main_subnet.id
  parent_resource_id   = var.storage.dl_storage_account.id
  parent_resource_name = var.storage.dl_storage_account.name
  name_suffix          = "dfs"
  endpoint_type        = "dfs"
  private_dns_zones    = [module.private_dns_zones.zones.dfs]
  count                = var.storage.dl_storage_account.is_hns_enabled ? 1 : 0
}