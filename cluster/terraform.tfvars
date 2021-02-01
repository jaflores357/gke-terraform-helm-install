cluster_name               = "jaf-us"
cluster_type               = "public"
cluster_node_version       = "1.16.15-gke.4901"
cluster_min_master_version = "1.16.15-gke.4901"
project                    = "poc-helm"
region                     = "us-central1"
network_name               = "default"
subnetwork_name            = "default"
env_pools                  = [
    {
      environment     = "core"
      machine_type    = "n1-standard-1"
      disk_size_gb    = 20
      zones_amount    = 2
      nodes_per_zone  = 1
    }
]
