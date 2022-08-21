output "output" {
  value = {
    private_endpoints_config = concat(
                                module.monitoring.output.private_endpoints_config,
                                module.key_vault.output.private_endpoints_config)
  }
}