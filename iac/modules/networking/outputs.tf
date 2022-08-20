output "output" {
  value = {
    vnet              = module.network.output.vnet
    main_subnet       = module.network.output.main_subnet
    db_public_subnet  = module.network.output.db_public_subnet
    db_private_subnet = module.network.output.db_private_subnet
    private_dns_zones = { for k, v in merge(azurerm_private_dns_zone.shared_private_dns_zone, azurerm_private_dns_zone.internal_private_dns_zone) : k => v.id }
  }
}