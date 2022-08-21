locals {
  config = {
    name_prefix          = "${var.clientName}-${var.projectName}-${var.env}"
    dashless_name_prefix = "${var.clientName}${var.projectName}${var.env}"
    resource_group_name  = "${var.clientName}-${var.projectName}-${var.env}-rg"
    location             = var.location
    deployer_object_id   = var.deployer_object_id
    tenant_id            = var.tenant_id
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
  }
}