# storage
resource "azurerm_role_assignment" "adf_on_storage" {
  scope                = var.storage.data_lake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.data_factory.factory.mi_id
  count                = var.data_factory != null ? 1 : 0
}

resource "azurerm_role_assignment" "synapse_on_storage" {
  scope                = var.storage.data_lake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.synapse.workspace.mi_id
  count                = var.synapse != null ? 1 : 0
}

resource "azurerm_role_assignment" "purview_on_storage" {
  scope                = var.storage.data_lake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.purview.account.mi_id
  count                = var.purview != null ? 1 : 0
}

resource "azurerm_role_assignment" "data_spn_on_storage" {
  scope                = var.storage.data_lake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.service_principal.spn.object_id
}


# databricks
resource "azurerm_role_assignment" "adf_on_databricks" {
  scope                = var.databricks_workspace.workspace.id
  role_definition_name = "Contributor"
  principal_id         = var.data_factory.factory.mi_id
  count                = (var.data_factory != null && var.databricks_workspace != null) ? 1 : 0
}

resource "azurerm_role_assignment" "synapse_on_databricks" {
  scope                = var.databricks_workspace.workspace.id
  role_definition_name = "Contributor"
  principal_id         = var.synapse.workspace.mi_id
  count                = (var.synapse != null && var.databricks_workspace != null) ? 1 : 0
}