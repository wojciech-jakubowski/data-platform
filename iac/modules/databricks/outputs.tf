output "output" {
  value = {
    workspace = {
      id   = azurerm_databricks_workspace.workspace.id
      name = azurerm_databricks_workspace.workspace.name
    }
    secrets = {
      "ClusterName"   = "small"
      "ClusterNameId" = "1234"
    }
  }
}