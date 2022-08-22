output "output" {
  value = {
    dl_storage_account = {
      id             = module.dl.storage_account.id
      name           = module.dl.storage_account.name
      is_hns_enabled = module.dl.storage_account.is_hns_enabled
      blob_endpoint  = module.dl.storage_account.blob_endpoint
      dfs_endpoint   = module.dl.storage_account.dfs_endpoint
      containers     = module.dl.storage_account.containers
    }
    secrets = {
        "DLStorageAccountKey" = module.dl.storage_account.key
        "DLConnectionString"  = module.dl.storage_account.connection_string
      }
  }
}