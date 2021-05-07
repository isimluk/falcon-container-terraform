variable "project_id" {
  description = "GCP Project ID (project needs to exist already) (Alternatively, set env variable TF_VAR_project_id)"
}

variable "region" {
  description = "region"
}

variable "zone" {
  description = "zone"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "container" {
  project = var.project_id
  service = "container.googleapis.com"
}
