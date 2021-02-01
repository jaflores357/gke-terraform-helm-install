variable "cluster_name" {
  description = "The GKE cluster name"
  type        = string
  default     = "jaf-us"
}

variable "cluster_type" {
  description = "Public or Private Cluster"
  type        = string
  default     = "public"
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
