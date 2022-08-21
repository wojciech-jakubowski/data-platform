output "output" {
  value = {
    key_vault_id = azurerm_key_vault.key_vault.id
    private_endpoints_config = [
      {
        resource_id   = azurerm_key_vault.key_vault.id
        endpoint_type = "vault"
        private_dns_zones = [
          var.networking.private_dns_zones.kv,
        ]
      }
    ]
  }
}