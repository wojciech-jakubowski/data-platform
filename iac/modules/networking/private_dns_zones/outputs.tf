output "zones" {
  value = { for k, v in merge(azurerm_private_dns_zone.shared_private_dns_zone, azurerm_private_dns_zone.internal_private_dns_zone) : k => v.id }
}