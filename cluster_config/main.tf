
provider "google" {
  version = "~> 3"
  credentials = file("./gke.json")
  region  = var.region
  project = var.project
}

provider "google-beta" {
  version = "~> 3"
  credentials = file("./gke.json")
  region  = var.region
  project = var.project
}

data "google_client_config" "default" {
}

data "google_container_cluster" "my_cluster" {
  name = var.cluster_name
  location = var.region
}

provider "kubernetes" {
  load_config_file = false

  host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
  )
}

resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
  }
  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind = "ServiceAccount"
    name = "tiller"
    namespace = "kube-system"
  }
}

provider "helm" {
  version         = "~> 0.10"
  install_tiller  =  true
  service_account = kubernetes_service_account.tiller.metadata.0.name
  namespace       = kubernetes_service_account.tiller.metadata.0.namespace
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.11.0"

  kubernetes {
    host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
    token = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
    )
  }
}
