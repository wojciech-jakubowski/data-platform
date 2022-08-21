resource "azurerm_resource_group" "rg" {
  name     = var.config.resource_group_name
  location = var.config.location
  tags     = var.config.tags
}