output "output" {
  value = {
    dl = module.dl.storage_account
    secrets = {
      "DLStorageAccountKey" = module.dl.storage_account.key
      "DLConnectionString"  = module.dl.storage_account.connection_string
    }
  }
}