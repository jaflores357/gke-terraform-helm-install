
provider "google" {
  version = "~> 3"
  credentials = file("./helm.json")
  region  = var.region
  project = var.project
}

provider "google-beta" {
  version = "~> 3"
  credentials = file("./helm.json")
  region  = var.region
  project = var.project
}
    
locals {
  cluster_ca_certificate = data.google_container_cluster.gke_cluster.master_auth != null ? data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate : ""
  endpoint               = data.google_container_cluster.gke_cluster.endpoint != null ? data.google_container_cluster.gke_cluster.endpoint : ""
  host                   = data.google_container_cluster.gke_cluster.endpoint != null ? "https://${data.google_container_cluster.gke_cluster.endpoint}" : ""
  context                = data.google_container_cluster.gke_cluster.name != null ? data.google_container_cluster.gke_cluster.name : ""
}

data "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.region
  project  = var.project
}

data "google_client_config" "provider" {}

data "template_file" "kubeconfig" {
  template = file("./kubeconfig-template.yaml.tpl")

  vars = {
    context                = local.context
    cluster_ca_certificate = local.cluster_ca_certificate
    endpoint               = local.endpoint
    token                  = data.google_client_config.provider.access_token
  }
}

resource "local_file" "kubeconfig" {
  content  = data.template_file.kubeconfig.rendered
  filename = "./kubeconfig-${var.cluster_name}"
}

