resource "google_container_node_pool" "node_pool" {
  name               = var.node_name
  cluster            = var.cluster
  location           = var.zone
  version            = var.version
  initial_node_count = var.initial_node_count

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  node_config {
    image_type   = var.image_type
    disk_size_gb = var.disk_size_gb
    machine_type = var.machine_type
    labels       = var.labels
    disk_type    = var.disk_type
    tags         = var.node_tags
    preemptible  = var.preemptible

    oauth_scopes = var.oauth_scopes
  }

  management {
    auto_repair  = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }
}
