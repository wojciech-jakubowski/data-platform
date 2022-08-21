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