resource "azurerm_key_vault" "key_vault" {
  name                       = "${var.config.name_prefix}-kv"
  location                   = var.config.location
  resource_group_name        = var.config.resource_group_name
  tenant_id                  = var.config.tenant_id
  soft_delete_retention_days = 7
  sku_name                   = "standard"
  tags                       = var.config.tags

  access_policy {
    tenant_id = var.config.tenant_id
    object_id = var.config.deployer_object_id

    key_permissions = [
      "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"
    ]

    secret_permissions = [
      "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set",
    ]

    certificate_permissions = [
      "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update",
    ]
  }

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = [var.config.deployer_ip_address]
  }
}

module "kv_private_endpoint" {
  source               = "../networking/private_endpoint"
  config               = var.config
  networking           = var.networking
  parent_resource_id   = azurerm_key_vault.key_vault.id
  parent_resource_name = azurerm_key_vault.key_vault.name
  endpoint_type        = "vault"
  private_dns_zones    = [var.networking.private_dns_zones.kv]
}

module "kv_diagnostic_settings" {
  source                     = "../monitoring/diagnostic_settings"
  config                     = var.config
  target_resource_id         = azurerm_key_vault.key_vault.id
  target_resource_name       = azurerm_key_vault.key_vault.name
  log_analytics_workspace_id = var.monitoring.log_analytics_workspace_id
  logs = {
    "AuditEvent" = {
      enabled                  = true
      retention_policy_enabled = true
      retention_policy_days    = 0
    }
    "AzurePolicyEvaluationDetails" = {
      enabled                  = true
      retention_policy_enabled = true
      retention_policy_days    = 0
    }
  }
  metrics = {
    "AllMetrics" = {
      enabled                  = true
      retention_policy_enabled = true
      retention_policy_days    = 0
    }
  }
}