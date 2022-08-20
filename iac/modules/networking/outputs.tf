output "output" {
  value = {
    vnet = module.network.output.vnet
    main_subnet = module.network.output.main_subnet
    db_public_subnet = module.network.output.db_public_subnet
    db_private_subnet = module.network.output.db_private_subnet
  }
}