variable "client_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "location" {
  type    = string
  default = "West Europe"
}

variable "deployer_ip_address" {
  type = string
}

variable "deployer_email" {
  type = string
}

variable "deploy_networking" {
  type    = bool
  default = false
}

variable "deploy_synapse" {
  type    = bool
  default = false
}

variable "deploy_data_factory" {
  type    = bool
  default = false
}

variable "deploy_databricks" {
  type    = bool
  default = false
}

variable "deploy_purview" {
  type    = bool
  default = false
}

variable "existing_rg_name" {
  type    = string
  default = null
}