provider "google" {
  credentials               = var.credentials
  project                   = var.project
  region                    = var.region
}

provider "kubernetes" {
  load_config_file       = "false"
  username               = var.master_username
  password               = var.master_password
  host                   = module.cluster.host
  client_certificate     = module.cluster.client_certificate
  client_key             = module.cluster.client_key
  cluster_ca_certificate = module.cluster.cluster_ca_certificate
}

#---------------------------------------------------------------------------#
# Uncomment the required lines or override other variables of your choice.  #
#---------------------------------------------------------------------------#
module "network" {
  source                    = "./modules/network"
  project                   = var.project
  network_name 				= var.network_name
  subnet_name				= var.subnet_name
}

module "instance" {
  source                    = "./modules/instance"
  project                   = var.project
  ssh_user                  = var.ssh_user
  ssh_key                   = var.ssh_key
  service_account_email     = var.service_account_email
  zone         				= var.zone
  depends_on                = [module.network]
}

module "cluster" {
  source               		= "./module/cluster"
  name                  	= var.name
  zone             		 	= var.zone
  kubernetes_version    	= var.kubernetes_version
  network_name 				= var.network_name
  nodes_subnetwork_name 	= var.subnet_name
  master_username       	= var.master_username
  master_password       	= var.master_password
  depends_on            	= [module.network]
}

module "node" {
  source             		= "./module/node"
  name               		= var.node_name
  location           		= var.zone
  gke_cluster_name   		= var.name
  machine_type       		= var.machine_type
  min_node_count     		= "1"
  max_node_count     		= "1"
  kubernetes_version 		= var.kubernetes_version
}

module "nginx-ingress-controller" {
  source  					= "byuoitav/nginx-ingress-controller/kubernetes"
  version 					= "0.1.14"
  depends_on 				= [module.node]
}

module "jenkins" {
  source       				= "./module/k8s/jenkins"
  ingress_host 				= "jenkins.izaitsava.playpit.by"
  depends_on   				= [module.nginx-ingress-controller]
}

