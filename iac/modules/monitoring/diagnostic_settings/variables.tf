variable "config" {}
variable "target_resource_id" {}
variable "target_resource_name" {}
variable "log_analytics_workspace_id" {}
variable "log_analytics_destination_type" {
  default = null
}
variable "logs" {}
variable "metrics" {}