resource "google_container_cluster" "cluster" {
  name                    	 	= var.name
  location                		= var.zone
  min_master_version      		= var.kubernetes_version
  network                 	 	= var.network_name
  subnetwork              		= var.subnet_name
  monitoring_service      		= var.monitoring_service
  logging_service         		= var.logging_service
  initial_node_count      	 	= 1
  remove_default_node_pool 	 	= true

  master_auth {
    username 				 	= var.master_username
    password				 	= var.master_password
    client_certificate_config {
      issue_client_certificate 	= true
    }
  }

  private_cluster_config {
    enable_private_endpoint 	= var.enable_private_endpoint
    enable_private_nodes    	= var.enable_private_nodes
    master_ipv4_cidr_block  	= var.master_ipv4_cidr_block
  }

  resource_labels 				= {
    kubernetescluster 			= var.name
  }

  lifecycle {
    ignore_changes 				= [
      node_pool,
      network,
      subnetwork,
    ]
  }
}
