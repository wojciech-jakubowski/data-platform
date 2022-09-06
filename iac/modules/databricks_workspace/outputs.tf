output "output" {
  value = {
    workspace = {
      id   = azurerm_databricks_workspace.workspace.id
      name = azurerm_databricks_workspace.workspace.name
      url  = azurerm_databricks_workspace.workspace.workspace_url
    }
  }
}