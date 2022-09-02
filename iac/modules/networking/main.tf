# DNS zones
module "private_dns_zones" {
  source                  = "./private_dns_zones"
  config                  = var.config
  deploy_synapse_zones    = var.deploy_synapse_zones
  deploy_databricks_zones = var.deploy_databricks_zones
  deploy_purview_zones    = var.deploy_purview_zones
}

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
  delegation {
    name = "databricks"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

resource "azurerm_subnet" "db_private_subnet" {
  name                 = "db_private"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.config.resource_group_name
  address_prefixes     = ["${local.ip_address_part_env_adjusted}.128/26"]
  delegation {
    name = "databricks"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}