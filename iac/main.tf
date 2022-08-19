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

module "config" {
  source      = "./modules/config"
  clientName  = var.clientName
  projectName = var.projectName
  location    = var.location
  tenant_id   = "1234"
  env         = var.env
}

module "resource_group" {
  source = "./modules/resource_group"
  config = module.config.output
}