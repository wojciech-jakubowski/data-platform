locals {
  config = {
    name_prefix          = "${var.client_name}-${var.project_name}-${var.env}"
    dashless_name_prefix = "${var.client_name}${var.project_name}${var.env}"
    resource_group_name  = "${var.client_name}-${var.project_name}-${var.env}-rg"
    location             = var.location
    deployer_object_id   = var.deployer_object_id
    deployer_ip_address  = var.deployer_ip_address
    tenant_id            = var.tenant_id
    project_name         = var.project_name
    client_name          = var.client_name
    env                  = var.env
    network_address = {
      first_octet  = 192
      second_octet = 168
      third_octet  = 0
    }
    tags = {
      tag_one = "tagOneValue"
      tag_two = "tagTwoValue"
    }
    synapse_aad_admin = {
      login     = "wojciech.jakubowski@outlook.com"
      object_id = var.deployer_object_id
    }

    deploy_networking   = var.deploy_networking
    deploy_data_factory = var.deploy_data_factory
    deploy_synapse      = var.deploy_synapse
    deploy_databricks   = var.deploy_databricks
    deploy_purview      = var.deploy_purview
  }
}