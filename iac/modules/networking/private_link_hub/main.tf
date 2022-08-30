resource "azurerm_synapse_private_link_hub" "private_link_hub" {
  name                = "${var.config.dashless_name_prefix}plh"
  resource_group_name = var.config.resource_group_name
  location            = var.config.location
}

module "private_link_hub_private_endpoint" {
  source               = "../private_endpoint"
  config               = var.config
  subnet_id            = var.subnet_id
  parent_resource_id   = azurerm_synapse_private_link_hub.private_link_hub.id
  parent_resource_name = azurerm_synapse_private_link_hub.private_link_hub.name
  endpoint_type        = "Web"
  private_dns_zones    = [var.private_dns_zone_id]
}

