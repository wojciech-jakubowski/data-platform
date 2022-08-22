output "output" {
  value = {
    workspace_id   = azurerm_synapse_workspace.workspace.id
    workspace_name = azurerm_synapse_workspace.workspace.name
    secrets = {
      "SynapseSQLAdminLogin"    = local.sql_admin_login
      "SynapseSQLAdminPassword" = random_password.password.result
    }
  }
}