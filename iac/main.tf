terraform {
  backend "azurerm" {
    resource_group_name  = "wj-common-rg"
    storage_account_name = "wjcommontfstatesa"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.20.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

data "azurerm_client_config" "current" {
}

module "config" {
  source             = "./modules/config"
  client_name        = var.clientName
  project_name       = var.projectName
  location           = var.location
  deployer_object_id = data.azurerm_client_config.current.object_id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  env                = var.env
}

module "resource_group" {
  source = "./modules/resource_group"
  config = module.config.output
}

module "monitoring" {
  source = "./modules/monitoring"
  config = module.config.output

  depends_on = [
    module.resource_group
  ]
}

module "key_vault" {
  source     = "./modules/key_vault"
  config     = module.config.output
  monitoring = module.monitoring.output

  depends_on = [
    module.resource_group
  ]
}

module "storage" {
  source     = "./modules/storage"
  config     = module.config.output
  monitoring = module.monitoring.output

  depends_on = [
    module.resource_group
  ]
}

module "data_factory" {
  source     = "./modules/data_factory"
  config     = module.config.output
  monitoring = module.monitoring.output
  key_vault  = module.key_vault.output

  depends_on = [
    module.resource_group
  ]
}

module "synapse" {
  source     = "./modules/synapse"
  config     = module.config.output
  monitoring = module.monitoring.output
  key_vault  = module.key_vault.output
  storage    = module.storage.output

  depends_on = [
    module.resource_group
  ]
}

module "purview" {
  source     = "./modules/purview"
  config     = module.config.output
  monitoring = module.monitoring.output
  key_vault  = module.key_vault.output

  depends_on = [
    module.resource_group
  ]
}

module "secrets" {
  source    = "./modules/secrets"
  key_vault = module.key_vault.output
  secrets = merge(
    module.monitoring.output.secrets,
    module.storage.output.secrets,
    module.synapse.output.secrets
  )

  depends_on = [
    module.resource_group
  ]
}

module "networking" {
  source     = "./modules/networking"
  config     = module.config.output
  key_vault  = module.key_vault.output
  monitoring = module.monitoring.output
  storage    = module.storage.output
  synapse    = module.synapse.output
  purview    = module.purview.output

  depends_on = [
    module.resource_group,
    module.monitoring
  ]
  count = module.config.output.deploy_networking ? 1 : 0
}

module "role_assingments" {
  source       = "./modules/aad/role_assignments"
  config       = module.config.output
  key_vault    = module.key_vault.output
  storage      = module.storage.output
  data_factory = module.data_factory.output
  synapse      = module.synapse.output
  purview      = module.purview.output
}
