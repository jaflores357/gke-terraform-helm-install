variable "cluster_name" {
  description = "The GKE cluster name"
  type        = string
  default     = "jaf-cluster"
}

variable "cluster_type" {
  description = "Public or Private Cluster"
  type        = string
  default     = "public"
}

variable "cluster_node_version" {
  description = "The GKE cluster version"
  type        = string
  default     = "1.13.12-gke.30"
}

variable "cluster_min_master_version" {
  description = "The GKE min Master cluster version"
  type        = string
  default     = "1.14.10-gke.50"
}

variable "project" {
  description = "The project ID to create the resources in."
  type        = string
  default     = "poc-helm"
}

variable "network_name" {
  description = "The Network name to create the resources in."
  type        = string
  default     = "default"
}

variable "subnetwork_name" {
  description = "The Subnetwork name to create the resources in."
  type        = string
  default     = "default"
}

variable "region" {
  description = "The region to create the resources in."
  type        = string
  default     = "us-central1"
}

variable "zones_count" {
  description = "The number of zones to create the resources in."
  type        = number
  default     = 1
}

variable "env_pools" {
  type = list(object({
    nodes_per_zone = number
    zones_amount = number
    environment = string
    machine_type = string
    disk_size_gb = number

  }))
  default = [
    {
      environment     = "test"
      machine_type    = "n1-standard-4"
      disk_size_gb    = 20
      nodes_per_zone  = 1
      zones_amount    = 1
    }
  ]
}

