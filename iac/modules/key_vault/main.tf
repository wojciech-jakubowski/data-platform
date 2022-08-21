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
    ip_rules = [ var.config.deployer_ip_address ]
  }
}