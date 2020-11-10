output "name" {
  description = "The static name of the GKE cluster"
  value       = google_container_cluster.cluster.name
}
output "kubernetes_version" {
  description = "The Kubernetes version used when creating or upgrading this cluster. This does not reflect the current version of master or worker nodes."
  value       = var.kubernetes_version
}
output "location" {
  description = "The region in which this cluster exists"
  value       = var.location
}
output "client_certificate" {
  value     = base64decode(google_container_cluster.cluster.master_auth.0.client_certificate)
  sensitive = true
}

output "client_key" {
  value     = base64decode(google_container_cluster.cluster.master_auth.0.client_key)
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = base64decode(google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)
  sensitive = true
}

output "host" {
  value = google_container_cluster.cluster.endpoint
}