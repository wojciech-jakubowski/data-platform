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
  features {}
}

data "azurerm_client_config" "current" {
}


module "config" {
  source      = "./modules/config"
  clientName  = var.clientName
  projectName = var.projectName
  location    = var.location
  tenant_id   = data.azurerm_client_config.current.tenant_id
  env         = var.env
}

module "resource_group" {
  source = "./modules/resource_group"
  config = module.config.output
}

module "networking" {
  source = "./modules/networking"
  config = module.config.output
}