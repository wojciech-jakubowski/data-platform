output "output" {
  value = {
    vnet = {
      id             = azurerm_virtual_network.vnet.id
      address_prefix = azurerm_virtual_network.vnet.address_space[0]
    }
    main_subnet = {
      id             = azurerm_subnet.main_subnet.id
      address_prefix = azurerm_subnet.main_subnet.address_prefixes[0]
    }
    db_public_subnet = {
      id             = azurerm_subnet.db_public_subnet.id
      name           = azurerm_subnet.db_public_subnet.name
      address_prefix = azurerm_subnet.db_public_subnet.address_prefixes[0]
    }
    db_private_subnet = {
      id             = azurerm_subnet.db_private_subnet.id
      name           = azurerm_subnet.db_private_subnet.name
      address_prefix = azurerm_subnet.db_private_subnet.address_prefixes[0]
    }

    private_dns_zones = module.private_dns_zones.zones
  }
}