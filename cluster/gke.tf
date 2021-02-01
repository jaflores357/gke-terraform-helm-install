
#---------------------------------
# Data
#---------------------------------

data "google_compute_network" "vpc_network" {
  name    = var.network_name
  project = var.project
}

data "google_compute_subnetwork" "vpc_subnetwork" {
  name    = var.subnetwork_name
  region  = var.region
  project = var.project
}

data "google_compute_zones" "available" {
  region  = var.region
  project = var.project
}

locals {
  zones = slice(data.google_compute_zones.available.names, 0, var.zones_count) 
} 


#---------------------------------
# GKE cluster
#---------------------------------

resource "google_container_cluster" "primary" {
  name               = var.cluster_name
  location           = var.region
  node_version       = var.cluster_min_master_version
  min_master_version = var.cluster_min_master_version
  
  remove_default_node_pool = true
  initial_node_count       = 1
  
  network    = data.google_compute_network.vpc_network.self_link
  subnetwork = data.google_compute_subnetwork.vpc_subnetwork.self_link
  
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  logging_service    = "logging.googleapis.com/kubernetes"

  maintenance_policy {
    daily_maintenance_window {
      start_time = "06:00"
    }
  }

  network_policy {
    enabled = true
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
    network_policy_config {
      disabled = false
    }
  }
  
}

resource "google_container_node_pool" "pools" {
  count          = length(var.env_pools)
  name           = "${var.env_pools[count.index].environment}-pool"
  version        = var.cluster_min_master_version
  location       = var.region
  cluster        = google_container_cluster.primary.name
  node_count     = var.env_pools[count.index].nodes_per_zone
  node_locations = slice(data.google_compute_zones.available.names, 0, var.env_pools[count.index].zones_amount)

  management {
    auto_repair = true
    auto_upgrade = false
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]
    machine_type = var.env_pools[count.index].machine_type
    disk_size_gb = var.env_pools[count.index].disk_size_gb
    disk_type    = "pd-standard"
    image_type   = "COS"
    tags         = ["${var.env_pools[count.index].environment}-pool"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

