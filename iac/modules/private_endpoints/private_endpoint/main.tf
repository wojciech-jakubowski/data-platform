locals {
  name_suffix           = var.name_suffix == "" ? "" : "-${var.name_suffix}"
  private_endpoint_name = "${var.parent_resource_name}${local.name_suffix}-pe"
}

resource "azurerm_private_endpoint" "pe" {
  name                = local.private_endpoint_name
  location            = var.config.location
  resource_group_name = var.config.resource_group_name
  subnet_id           = var.subnet_id
  private_dns_zone_group {
    name                 = "${local.private_endpoint_name}-pe-dns-zone-group"
    private_dns_zone_ids = var.private_dns_zones
  }

  private_service_connection {
    name                           = "${local.private_endpoint_name}-pe-connection"
    private_connection_resource_id = var.parent_resource_id
    subresource_names              = [var.endpoint_type]
    is_manual_connection           = false
  }
  tags = var.config.tags
}