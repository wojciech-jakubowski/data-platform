locals {
  config = {
    namePrefix         = "${var.clientName}-${var.projectName}-${var.env}"
    dashlessNamePrefix = "${var.clientName}${var.projectName}${var.env}"
    resource_group_name = "${var.clientName}-${var.projectName}-${var.env}-rg"
    location           = var.location
    tenant_id          = var.tenant_id
    env                = var.env
    networkAddress = {
      firstOctet  = 192
      secondOctet = 168
      thirdOctet  = 0
    }
    tags = {
      tagOne = "tagOneValue"
      tagTwo = "tagTwoValue"
    }
  }
}