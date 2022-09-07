resource "azurerm_resource_group" "rg" {
  name     = var.config.resource_group_name
  location = var.config.location
  tags     = var.config.tags

  count = var.config.deploy_resource_group ? 1 : 0
}