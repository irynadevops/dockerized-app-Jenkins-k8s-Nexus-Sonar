variable "name" {
  
}

variable "gke_cluster_name" {
  
}

variable "location" {

}

variable "initial_node_count" {

  default     = "1"
}

variable "min_node_count" {

}

variable "max_node_count" {

}
variable "kubernetes_version" {

}

variable "node_image_type" {

}

variable "machine_type" {
  default     = "n1-standard-1"
}

variable "disk_size_in_gb" {
  default     = "60"
}

variable "node_tags" {
  type        = list
  default     = []
}

variable "node_labels" {
  type        = map
  default     = {}
}

variable "disk_type" {
  default     = "pd-standard"
}

variable "oauth_scopes" {
  type        = list
  default = [
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
  ]
}
variable "auto_repair" {
  default     = true
}

variable "auto_upgrade" {
  default     = false
}
variable "preemptible_nodes" {
  default     = false
}
