resource "azuread_application" "application" {
  display_name = "${var.config.name_prefix}-spn2"
  owners       = [var.config.deployer_object_id]
}

resource "azuread_service_principal" "spn" {
  application_id = azuread_application.application.application_id
  owners         = [var.config.deployer_object_id]
}

resource "azuread_service_principal_password" "spn_password" {
  service_principal_id = azuread_service_principal.spn.object_id
}