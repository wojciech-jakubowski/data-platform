output "output" {
  value = {
    spn = {
      object_id = azuread_service_principal.spn.object_id
      client_id = azuread_application.application.application_id
      name      = azuread_application.application.display_name
    }

    secrets = {
      "DataSpnName"         = azuread_application.application.display_name
      "DataSpnClientId"     = azuread_application.application.application_id
      "DataSpnClientSecret" = azuread_service_principal_password.spn_password.value
    }
  }
}