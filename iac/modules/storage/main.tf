module "dl" {
  source         = "./storage_account"
  config         = var.config
  monitoring     = var.monitoring
  name           = "dl"
  is_hns_enabled = true
  containers     = ["raw", "conformed", "prepared"]
}