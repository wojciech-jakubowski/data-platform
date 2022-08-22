module "dl" {
  source         = "./storage_account"
  config         = var.config
  name           = "dl"
  is_hns_enabled = true
  containers     = ["raw", "conformed", "prepared"]
}