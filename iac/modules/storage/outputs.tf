output "output" {
  value = {
    dl_storage_account = {
      id                = module.dl.output.storage_account_id
      account_key       = module.dl.output.account_key
      connection_string = module.dl.output.connection_string
    }
  }
}