#---------------------------------
# Providers
#---------------------------------

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

module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "4.0.0"

  project_id                  = var.project

  activate_apis = [
    "serviceusage.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "pubsub.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
    "container.googleapis.com",
    "oslogin.googleapis.com",
    "containerregistry.googleapis.com",
    "compute.googleapis.com",
    "deploymentmanager.googleapis.com",
    "replicapool.googleapis.com",
    "replicapoolupdater.googleapis.com",
    "resourceviews.googleapis.com",
    "cloudbuild.googleapis.com",
    "sourcerepo.googleapis.com",
  ]
}
