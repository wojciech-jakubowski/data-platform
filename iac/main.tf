terraform {
  backend "azurerm" {
    resource_group_name  = "wj-common-rg"
    storage_account_name = "wjcommontfstatesa"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.19.0"
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
  clientName         = var.clientName
  projectName        = var.projectName
  location           = var.location
  deployer_object_id = data.azurerm_client_config.current.object_id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  env                = var.env
}

module "resource_group" {
  source = "./modules/resource_group"
  config = module.config.output
}

module "networking" {
  source = "./modules/networking"
  config = module.config.output
}

module "monitoring" {
  source     = "./modules/monitoring"
  config     = module.config.output
  networking = module.networking.output
}

module "key_vault" {
  source     = "./modules/key_vault"
  config     = module.config.output
  networking = module.networking.output
  monitoring = module.monitoring.output
}

module "storage" {
  source     = "./modules/storage"
  config     = module.config.output
  networking = module.networking.output
  monitoring = module.monitoring.output
}

module "secrets" {
  source     = "./modules/secrets"
  key_vault  = module.key_vault.output
  monitoring = module.monitoring.output
  storage    = module.storage.output
}