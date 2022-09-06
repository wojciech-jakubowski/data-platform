output "output" {
  value = {
    data_lake = module.dl.storage_account
    secrets = {
      "DLStorageAccountKey" = module.dl.storage_account.key
      "DLConnectionString"  = module.dl.storage_account.connection_string
    }
  }
}