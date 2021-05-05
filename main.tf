variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "zone" {
  description = "zone"
}

variable "falcon_client_id" {
  description = "OAuth2 API Credentials for CrowdStrike Falcon platform (used to retrieve container image)"
}

variable "falcon_client_secret" {
  description = "OAuth2 API Credentials for CrowdStrike Falcon platform (used to retrieve container image)"
}

variable "falcon_cid" {
  description = "CrowdStrike Falcon CID (full string)"
}

provider "google" {
  project = var.project_id
  region  = var.region
}
