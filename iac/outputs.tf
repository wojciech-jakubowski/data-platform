output "output" {
  value = {
    #stroage = module.storage.output.dl_storage_account.containers
  }
}