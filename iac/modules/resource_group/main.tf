resource "azurerm_resource_group" "rg" {
  name     = "${var.config.namePrefix}-rg"
  location = var.config.location
}