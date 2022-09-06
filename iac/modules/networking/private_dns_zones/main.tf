locals {
  common_internal_private_dns_zones = {
    kv : "privatelink.vaultcore.azure.net"
    dfs : "privatelink.dfs.core.windows.net"
    blob : "blob.core.windows.net"

  }
  synapse_internal_private_dns_zones = var.deploy_synapse_zones ? {
    syn_sql : "privatelink.sql.azuresynapse.net"
    syn_dev : "privatelink.dev.azuresynapse.net"
  } : {}
  purview_internal_private_dns_zones = var.deploy_purview_zones ? {
    pur_por : "privatelink.purviewstudio.azure.com"
  } : {}

  internal_private_dns_zones = merge(
    local.common_internal_private_dns_zones,
    local.synapse_internal_private_dns_zones,
  local.purview_internal_private_dns_zones)

  internal_private_dns_zones_rg = var.config.resource_group_name

  monitoring_shared_private_dns_zones = {
    mon : "privatelink.monitor.azure.com"
    ods : "privatelink.ods.opinsights.azure.com"
    oms : "privatelink.oms.opinsights.azure.com"
    asc : "privatelink.agentsvc.azure-automation.net"
  }
  synapse_shared_private_dns_zones =  var.deploy_synapse_zones ? {
    syn : "privatelink.azuresynapse.net"
  } : {}
  purview_shared_private_dns_zones = var.deploy_purview_zones ? {
    pur_acc : "privatelink.purview.azure.com"
  } : {}
  databricks_shared_private_dns_zones = var.deploy_databricks_zones ? {
    db : "privatelink.azuredatabricks.net"
  } : {}

  shared_private_dns_zones = merge(
    local.monitoring_shared_private_dns_zones,
    local.synapse_shared_private_dns_zones,
    local.purview_shared_private_dns_zones,
  local.databricks_shared_private_dns_zones)

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