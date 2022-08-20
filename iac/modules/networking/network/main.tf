locals {
  env_address_adjustment = {
    "dev" : 0
    "test" : 1
    "uat" : 2
    "prod" : 3
  }
  third_octet_env_adjusted     = var.config.network_address.third_octet + local.env_address_adjustment[var.config.env]
  ip_address_part_env_adjusted = "${var.config.network_address.first_octet}.${var.config.network_address.second_octet}.${local.third_octet_env_adjusted}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.config.name_prefix
  location            = var.config.location
  resource_group_name = var.config.resource_group_name
  address_space       = ["${local.ip_address_part_env_adjusted}.0/24"]
  tags                = var.config.tags
}

resource "azurerm_subnet" "main_subnet" {
  name                 = "main"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.config.resource_group_name
  address_prefixes     = ["${local.ip_address_part_env_adjusted}.0/26"]
}

resource "azurerm_subnet" "db_public_subnet" {
  name                 = "db_public"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.config.resource_group_name
  address_prefixes     = ["${local.ip_address_part_env_adjusted}.64/26"]
}

resource "azurerm_subnet" "db_private_subnet" {
  name                 = "db_private"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.config.resource_group_name
  address_prefixes     = ["${local.ip_address_part_env_adjusted}.128/26"]
}