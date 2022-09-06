output "output" {
  value = {
    workspace = {
      id    = azurerm_synapse_workspace.workspace.id
      name  = azurerm_synapse_workspace.workspace.name
      mi_id = azurerm_synapse_workspace.workspace.identity[0].principal_id
    }
    secrets = {
      "SynapseSQLAdminLogin"    = local.sql_admin_login
      "SynapseSQLAdminPassword" = random_password.password.result
    }
  }
}