locals {
  internal_private_dns_zones = {
    kv : "privatelink.vaultcore.azure.net"
    dfs : "privatelink.dfs.core.windows.net"
    blob : "blob.core.windows.net"
    syn_sql : "privatelink.sql.azuresynapse.net"
    syn_dev : "privatelink.dev.azuresynapse.net"
    pur_por : "privatelink.purviewstudio.azure.com"
  }
  internal_private_dns_zones_rg = var.config.resource_group_name

  shared_private_dns_zones = {
    mon : "privatelink.monitor.azure.com"
    ods : "privatelink.ods.opinsights.azure.com"
    oms : "privatelink.oms.opinsights.azure.com"
    asc : "privatelink.agentsvc.azure-automation.net"
    syn : "privatelink.azuresynapse.net"
    pur_acc: "privatelink.purview.azure.com"
  }
  shared_private_dns_zones_rg = var.config.resource_group_name
}

resource "azurerm_private_dns_zone" "shared_private_dns_zone" {
  for_each            = local.shared_private_dns_zones
  name                = each.value
  resource_group_name = local.shared_private_dns_zones_rg
  tags                = var.config.tags
}

resource "azurerm_private_dns_zone" "internal_private_dns_zone" {
  for_each            = local.internal_private_dns_zones
  name                = each.value
  resource_group_name = local.internal_private_dns_zones_rg
  tags                = var.config.tags
}