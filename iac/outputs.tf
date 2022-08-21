output "output" {
  value = {
    x = module.storage.output.dl_storage_account.id
  }
}