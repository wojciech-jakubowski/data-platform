output "output" {
  value = {
    private_dns_zones = module.networking.output.private_dns_zones
  } 
}