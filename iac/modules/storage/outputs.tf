output "output" {
  value = {
    dl_storage_account = {
      id             = module.dl.storage_account.id
      name           = module.dl.storage_account.name
      is_hns_enabled = module.dl.storage_account.is_hns_enabled
      secrets = {
        "DLStorageAccountKey" = module.dl.storage_account.key
        "DLConnectionString"  = module.dl.storage_account.connection_string
      }
    }
  }
}