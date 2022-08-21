locals {
  endpoints_map = { for v in var.private_endpoints_config: v.endpoint_type => v }
}


resource "azurerm_private_endpoint" "pe" {
  for_each            = local.endpoints_map
  name                = "${each.value.parent_resource_name}${lookup(each.value, "name_suffix", "") != "" ? "-${each.value["name_suffix"]}" : ""}-pe"
  location            = var.config.location
  resource_group_name = var.config.resource_group_name
  subnet_id           = var.networking.main_subnet.id
  private_dns_zone_group {
    name                 = "${each.value.parent_resource_name}-pe-dns-zone-group"
    private_dns_zone_ids = each.value.private_dns_zones
  }

  private_service_connection {
    name                           = "${each.value.parent_resource_name}-pe-connection"
    private_connection_resource_id = each.value.parent_resource_id
    subresource_names = [ each.value.endpoint_type ]
    is_manual_connection           = false
  }
}