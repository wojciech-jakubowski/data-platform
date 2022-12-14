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
  identity {
    type = "SystemAssigned"
  }


  network_rules {
    bypass         = ["AzureServices"]
    default_action = var.config.deploy_networking ? "Deny" : "Allow"
    ip_rules       = var.config.deploy_networking ? [var.config.deployer_ip_address] : []
  }
}

resource "azurerm_storage_container" "container" {
  for_each              = toset(var.containers)
  name                  = each.key
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

module "diagnostic_settings" {
  source                     = "../../monitoring/diagnostic_settings"
  config                     = var.config
  target_resource_id         = "${azurerm_storage_account.sa.id}/blobServices/default"
  target_resource_name       = azurerm_storage_account.sa.name
  log_analytics_workspace_id = var.monitoring.log_analytics.id
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