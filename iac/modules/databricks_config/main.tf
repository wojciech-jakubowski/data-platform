terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

resource "databricks_cluster" "single_node_cluster" {
  cluster_name            = "Single Node"
  spark_version           = "10.4.x-scala2.12"
  node_type_id            = "Standard_DS3_v2"
  autotermination_minutes = var.config.env == "dev" ? 60 : 15
  is_pinned               = true

  spark_conf = {
    "spark.databricks.cluster.profile" : "singleNode"
    "spark.master" : "local[*]"
  }

  custom_tags = {
    "ResourceClass" = "SingleNode"
  }
}

resource "databricks_cluster" "small_cluster" {
  cluster_name            = "Shared Small"
  spark_version           = "10.4.x-scala2.12"
  node_type_id            = "Standard_DS3_v2"
  autotermination_minutes = 15
  is_pinned               = true
  num_workers             = 2
}

resource "time_sleep" "wait_for_kvdns" {
  create_duration = "60s"

  depends_on = [
    databricks_cluster.small_cluster
  ]
}

resource "databricks_secret_scope" "kv" {
  name = "KVSecretScope"

  keyvault_metadata {
    resource_id = var.key_vault.vault.id
    dns_name    = var.key_vault.vault.uri
  }

  depends_on = [
    time_sleep.wait_for_kvdns
  ]
}