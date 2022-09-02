output "scope" {
  value = {
    id   = azurerm_monitor_private_link_scope.pes.id
    name = azurerm_monitor_private_link_scope.pes.name
  }
}