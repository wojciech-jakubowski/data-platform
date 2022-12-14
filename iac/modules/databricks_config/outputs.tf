output "output" {
  value = {
    secrets = {
      "SingleNodeClusterName"  = databricks_cluster.single_node_cluster.cluster_name
      "SingleNodeClusterId"    = databricks_cluster.single_node_cluster.id
      "SharedSmallClusterName" = databricks_cluster.small_cluster.cluster_name
      "SharedSmallClusterId"   = databricks_cluster.small_cluster.id
    }
  }
}