resource "azurerm_storage_account" "sa" {
  name                              = "${var.config.dashless_name_prefix}${var.name}sa"
  resource_group_name               = var.config.resource_group_name
  location                          = var.config.location
  account_kind                      = "StorageV2"
  account_tier                      = "Standard"
  account_replication_type          = "GRS"
  access_tier                       = "Hot"
  is_hns_enabled                    = var.is_hns_enabled
  infrastructure_encryption_enabled = true
  tags                              = var.config.tags

  network_rules {
    bypass         = ["AzureServices"]
    default_action = "Deny"
    ip_rules       = [var.config.deployer_ip_address]
  }
}

module "sa_blob_private_endpoint" {
  source               = "../../networking/private_endpoint"
  config               = var.config
  networking           = var.networking
  parent_resource_id   = azurerm_storage_account.sa.id
  parent_resource_name = azurerm_storage_account.sa.name
  name_suffix          = "blob"
  endpoint_type        = "blob"
  private_dns_zones    = [var.networking.private_dns_zones.blob]
}

module "sa_dfs_private_endpoint" {
  source               = "../../networking/private_endpoint"
  config               = var.config
  networking           = var.networking
  parent_resource_id   = azurerm_storage_account.sa.id
  parent_resource_name = azurerm_storage_account.sa.name
  name_suffix          = "dfs"
  endpoint_type        = "dfs"
  private_dns_zones    = [var.networking.private_dns_zones.dfs]
  count                = var.is_hns_enabled ? 1 : 0
}

resource "azurerm_storage_container" "container" {
  for_each              = toset(var.containers)
  name                  = each.key
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

# module "sa_diagnostic_settings" {
#   source = "../../monitoring/diagnostic_settings"
#   config = var.config
#   target_resource_id = azurerm_storage_account.sa.id
#   target_resource_name = azurerm_storage_account.sa.name
#   log_analytics_workspace_id = var.monitoring.log_analytics_workspace_id
#   logs = [

#   ]

# }