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
  location                             = var.config.location
  storage_data_lake_gen2_filesystem_id = "${var.storage.dl_storage_account.dfs_endpoint}/synapse"
  sql_administrator_login              = local.sql_admin_login
  sql_administrator_login_password     = random_password.password.result
  managed_virtual_network_enabled      = true

  #   aad_admin {
  #     login     = "AzureAD Admin"
  #     object_id = "00000000-0000-0000-0000-000000000000"
  #     tenant_id = "00000000-0000-0000-0000-000000000000"
  #   }

  identity {
    type = "SystemAssigned"
  }

  tags = var.config.tags
}
