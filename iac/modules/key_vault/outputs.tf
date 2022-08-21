output "output" {
  value = {
    key_vault_id = azurerm_key_vault.key_vault.id
    private_endpoints_config = [
      {
        parent_resource_id   = azurerm_key_vault.key_vault.id
        parent_resource_name = azurerm_key_vault.key_vault.name
        endpoint_type = "vault"
        private_dns_zones = [
          var.networking.private_dns_zones.kv,
        ]
      }
    ]
  }
}