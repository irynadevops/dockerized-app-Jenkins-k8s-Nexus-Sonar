#----------------------------------------#
# Create compute slave instances   		 #
#----------------------------------------#

resource "google_compute_instance" "instance" {
    name                        = var.instance_name
    project                     = var.project
    machine_type                = var.machine_type
    
    metadata = {
        ssh-keys                = "${var.ssh_user}:${var.ssh_key}"
    }
    
    metadata_startup_script     = file("install.sh")
    
    boot_disk {
        initialize_params {
            type                = var.boot_disk_type
            size                = var.boot_disk_size
            image               = "${var.image_project}/${var.image_family}"
        }
    }

    network_interface {
        network                 = var.network
        subnetwork              = var.subnet
        access_config {
        }
    }
    tags                        = var.slave_tags
    
    scheduling {
        on_host_maintenance     = var.scheduling_on_host_maintenance
        automatic_restart       = var.scheduling_automatic_restart
        preemptible             = var.scheduling_preemptible
    }
    
    service_account {
        email                   = var.service_account_email
        scopes                  = var.service_account_scopes
    }
}


