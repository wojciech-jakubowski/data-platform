output "output" {
  value = {
    stroage = module.storage.output.dl_storage_account.containers
    b       = module.storage.output.dl_storage_account.blob_endpoint
    d       = module.storage.output.dl_storage_account.dfs_endpoint
  }
}