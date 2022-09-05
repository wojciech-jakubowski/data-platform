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
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.28.1"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.2.1"
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
  client_name        = var.client_name
  project_name       = var.project_name
  location           = var.location
  deployer_object_id = data.azurerm_client_config.current.object_id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  env                = var.env

  deploy_networking   = true
  deploy_data_factory = false
  deploy_synapse      = false
  deploy_databricks   = true
  deploy_purview      = false
}

module "resource_group" {
  source = "./modules/resource_group"
  config = module.config.output
}

module "networking" {
  source                  = "./modules/networking"
  config                  = module.config.output
  deploy_synapse_zones    = module.config.output.deploy_synapse
  deploy_databricks_zones = module.config.output.deploy_databricks
  deploy_purview_zones    = module.config.output.deploy_purview

  depends_on = [
    module.resource_group
  ]
  count = module.config.output.deploy_networking ? 1 : 0
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

module "service_principal" {
  source = "./modules/service_principal"
  config = module.config.output
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

  count = module.config.output.deploy_data_factory ? 1 : 0
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

  count = module.config.output.deploy_synapse ? 1 : 0
}

module "databricks_workspace" {
  source     = "./modules/databricks_workspace"
  config     = module.config.output
  monitoring = module.monitoring.output
  networking = module.config.output.deploy_networking ? module.networking[0].output : null

  depends_on = [
    module.resource_group
  ]

  count = module.config.output.deploy_databricks ? 1 : 0
}

provider "databricks" {
  host  = module.config.output.deploy_databricks ? module.databricks_workspace[0].output.workspace.url : null
  alias = "databricks_config"
}

module "databricks_config" {
  source    = "./modules/databricks_config"
  config    = module.config.output
  key_vault = module.key_vault.output
  count     = module.config.output.deploy_databricks ? 1 : 0

  providers = {
    databricks = databricks.databricks_config
  }

  depends_on = [
    module.databricks_workspace[0]
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

  count = module.config.output.deploy_purview ? 1 : 0
}

module "secrets" {
  source    = "./modules/secrets"
  key_vault = module.key_vault.output
  secrets = merge(
    module.service_principal.output.secrets,
    module.monitoring.output.secrets,
    module.storage.output.secrets,
    module.config.output.deploy_synapse ? module.synapse[0].output.secrets : {},
    module.config.output.deploy_databricks ? module.databricks_config[0].output.secrets : {},
  )

  depends_on = [
    module.resource_group,
    module.key_vault
  ]
}

module "role_assingments" {
  source            = "./modules/role_assignments"
  config            = module.config.output
  key_vault         = module.key_vault.output
  storage           = module.storage.output
  service_principal = module.service_principal.output
  data_factory      = module.config.output.deploy_data_factory ? module.data_factory[0].output : null
  synapse           = module.config.output.deploy_synapse ? module.synapse[0].output : null
  databricks_workspace        = module.config.output.deploy_databricks ? module.databricks_workspace[0].output : null
  purview           = module.config.output.deploy_purview ? module.purview[0].output : null
}

module "private_endpoints" {
  source     = "./modules/private_endpoints"
  config     = module.config.output
  key_vault  = module.key_vault.output
  monitoring = module.monitoring.output
  storage    = module.storage.output
  networking = module.config.output.deploy_networking ? module.networking[0].output : null
  synapse    = module.config.output.deploy_synapse ? module.synapse[0].output : null
  databricks_workspace = module.config.output.deploy_databricks ? module.databricks_workspace[0].output : null
  purview    = module.config.output.deploy_purview ? module.purview[0].output : null

  depends_on = [
    module.resource_group,
    module.networking[0],
    module.monitoring
  ]
  count = module.config.output.deploy_networking ? 1 : 0
}
