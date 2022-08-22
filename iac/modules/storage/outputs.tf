output "output" {
  value = {
    dl_storage_account = {
      id = module.dl.output.storage_account_id
      secrets = {
        "DLStorageAccountKey" = module.dl.output.account_key
        "DLConnectionString"  = module.dl.output.connection_string
      }
    }
  }
}