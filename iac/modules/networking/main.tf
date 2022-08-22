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
  subnet_id           = module.network.vnet.main_subnet.id
  parent_resource_id   = var.key_vault.key_vault.id
  parent_resource_name = var.key_vault.key_vault.name
  endpoint_type        = "vault"
  private_dns_zones    = [module.private_dns_zones.zones.kv]
}

# monitoring
resource "azurerm_monitor_private_link_scope" "pes" {
  name                = "${var.config.name_prefix}-pes"
  resource_group_name = var.config.resource_group_name
  tags                = var.config.tags
}

resource "azurerm_monitor_private_link_scoped_service" "pes_lwg_service" {
  name                = "${var.config.name_prefix}-pes-lgw"
  resource_group_name = var.config.resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.pes.name
  linked_resource_id  = var.monitoring.log_analytics_workspace.id
}

resource "azurerm_monitor_private_link_scoped_service" "pes_ai_service" {
  name                = "${var.config.name_prefix}-pes-ai"
  resource_group_name = var.config.resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.pes.name
  linked_resource_id  = var.monitoring.app_insights.id
}

module "pes_private_endpoint" {
  source               = "./private_endpoint"
  config               = var.config
  subnet_id           = module.network.vnet.main_subnet.id
  parent_resource_id   = azurerm_monitor_private_link_scope.pes.id
  parent_resource_name = azurerm_monitor_private_link_scope.pes.name
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
  subnet_id           = module.network.vnet.main_subnet.id
  parent_resource_id   = var.storage.dl_storage_account.id
  parent_resource_name = var.storage.dl_storage_account.name
  name_suffix          = "dfs"
  endpoint_type        = "dfs"
  private_dns_zones    = [module.private_dns_zones.zones.dfs]
  count                = var.storage.dl_storage_account.is_hns_enabled ? 1 : 0
}