locals {
    envAddressAdjustment = {
        "dev" : 0
        "test" : 1
        "uat" : 2
        "prod" : 3
    }
    thirdOctetEnvAdjusted = var.config.networkAddress.thirdOctet + local.envAddressAdjustment[var.config.env]
    ipAddressPartEnvAdjusted = "${var.config.networkAddress.firstOctet}.${var.config.networkAddress.secondOctet}.${local.thirdOctetEnvAdjusted}"
}

resource "azurerm_virtual_network" "vnet" {
  name =               "${var.config.namePrefix}"
  location            = var.config.location
  resource_group_name = var.config.resource_group_name
  address_space       = ["${local.ipAddressPartEnvAdjusted}.0/24"]
  tags = var.config.tags
}

resource "azurerm_subnet" "main_subnet" {
  name = "main"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = var.config.resource_group_name
  address_prefixes = ["${local.ipAddressPartEnvAdjusted}.0/26"]
}

resource "azurerm_subnet" "db_public_subnet" {
  name = "db_public"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = var.config.resource_group_name
  address_prefixes = ["${local.ipAddressPartEnvAdjusted}.64/26"]
}

resource "azurerm_subnet" "db_private_subnet" {
  name = "db_private"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = var.config.resource_group_name
  address_prefixes = ["${local.ipAddressPartEnvAdjusted}.128/26"]
}