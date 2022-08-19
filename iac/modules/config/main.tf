locals {
  config = {
    namePrefix         = "${var.clientName}-${var.projectName}-${var.env}"
    dashlessNamePrefix = "${var.clientName}${var.projectName}${var.env}"
    location           = var.location
    tenant_id          = var.tenant_id
    networkAddress = {
      firstOctet  = 10
      secondOctet = 1
      thirdOctet  = 1
    }
    tags = {
      tagOne = "tagOneValue"
      tagTwo = "tagTwoValue"
    }
  }
}