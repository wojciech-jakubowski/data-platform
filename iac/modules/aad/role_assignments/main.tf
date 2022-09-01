# storage
resource "azurerm_role_assignment" "adf_on_storage" {
  scope                = var.storage.dl.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.data_factory.adf.mi_id
  count                = var.data_factory != null ? 1 : 0
}

resource "azurerm_role_assignment" "synapse_on_storage" {
  scope                = var.storage.dl.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.synapse.workspace.mi_id
  count                = var.synapse != null ? 1 : 0
}