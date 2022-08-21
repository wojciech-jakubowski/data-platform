output "output" {
  value = {
    #private_endpoints_config  = { for v in concat(module.monitoring.output.private_endpoints_config, module.key_vault.output.private_endpoints_config): v.endpoint_type => v }
  }
}