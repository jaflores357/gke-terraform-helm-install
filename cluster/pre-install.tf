
# module "gke_auth" {
#   source           = "terraform-google-modules/kubernetes-engine/google//modules/auth"
#   project_id       = var.project
#   cluster_name     = var.cluster_name
#   location         = var.region
#   depends_on = [
#      google_container_cluster.primary,
#   ]

# }


# provider "kubernetes" {
#   version = ">= 1.4.0"
#   load_config_file = false

#   cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
#   host                   = module.gke_auth.host
#   #token                  = module.gke_auth.token
#   username = "digibee-lab-admin"
#   password = "2THyjgNM2UqFuB6G34WXEv4"

# }

# resource "local_file" "kubeconfig" {
#   content  = module.gke_auth.kubeconfig_raw
#   filename = "${path.module}/credentials/kubeconfig-${var.cluster_name}"
# }

# resource "kubernetes_service_account" "tiller" {
#   metadata {
#     name      = "tiller"
#     namespace = "kube-system"
#   }
#   automount_service_account_token = true
#   depends_on = [
#      google_container_cluster.primary,
#   ]
# }

# resource "kubernetes_cluster_role_binding" "tiller" {
#   metadata {
#     name = "tiller"
#   }
#   role_ref {
#     kind      = "ClusterRole"
#     name      = "cluster-admin"
#     api_group = "rbac.authorization.k8s.io"
#   }
#   subject {
#     kind = "ServiceAccount"
#     name = "tiller"
#     namespace = "kube-system"
#   }
#   depends_on = [
#      google_container_cluster.primary,
#   ]

# }


# # resource "kubernetes_deployment" "tiller_deploy" {
# #   metadata {
# #     name      = "tiller-deploy"
# #     namespace = kubernetes_service_account.tiller.metadata.0.namespace

# #     labels = {
# #       app  = "helm"
# #       name = "tiller"
# #     }
# #   }

# #   spec {
# #     replicas = 1

# #     selector {
# #       match_labels = {
# #         app  = "helm"
# #         name = "tiller"
# #       }
# #     }

# #     template {
# #       metadata {
# #         labels = {
# #           app  = "helm"
# #           name = "tiller"
# #         }
# #       }

# #       spec {
# #         container {
# #           name              = "tiller"
# #           image             = "gcr.io/kubernetes-helm/tiller:v2.11.0"
# #           image_pull_policy = "IfNotPresent"

# #           port {
# #             name           = "tiller"
# #             container_port = 44134
# #           }

# #           port {
# #             name           = "http"
# #             container_port = 44135
# #           }

# #           env {
# #             name  = "TILLER_NAMESPACE"
# #             value = kubernetes_service_account.tiller.metadata.0.namespace
# #           }

# #           env {
# #             name  = "TILLER_HISTORY_MAX"
# #             value = 0
# #           }

# #           liveness_probe {
# #             http_get {
# #               path = "/liveness"
# #               port = 44135
# #             }

# #             initial_delay_seconds = 1
# #             timeout_seconds       = 1
# #           }

# #           readiness_probe {
# #             http_get {
# #               path = "/readiness"
# #               port = 44135
# #             }

# #             initial_delay_seconds = 1
# #             timeout_seconds       = 1
# #           }
# #         }
# #       }
# #     }
# #   }
# # }

# # resource "kubernetes_service" "tiller_service" {
# #   metadata {
# #     name = "tiller-deploy"
# #     namespace = kubernetes_service_account.tiller.metadata.0.namespace
# #   }
# #   spec {
# #     selector = {
# #       app = "helm"
# #       name = "tiller"
# #     }
# #     port {
# #       name        = "tiller"
# #       port        = 44134
# #       target_port = "tiller"
# #     }

# #     type = "ClusterIP"
# #   }
# # }

# provider "helm" {
#   version = "~> 0.10"  
#   install_tiller =  true
#   service_account = kubernetes_service_account.tiller.metadata.0.name
#   namespace       = kubernetes_service_account.tiller.metadata.0.namespace
#   tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.11.0" 
#   kubernetes {
#     cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
#     host                   = module.gke_auth.host
#     #token                  = module.gke_auth.token
#     username = "digibee-lab-admin"
#     password = "2THyjgNM2UqFuB6G34WXEv4"
#   }
# }
