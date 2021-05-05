resource "google_compute_instance" "vm_instance" {
  name         = "gke-admin-vm"
  machine_type = "f1-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {}
  }

  metadata_startup_script = file("gke-admin-vm.sh")

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.gke-admin-vm.email
    scopes = ["cloud-platform"]
  }
}

resource "google_service_account" "gke-admin-vm" {
  account_id   = "service-account-id"
  display_name = "Service Account for GKE Admin VM"
}

resource "google_project_iam_binding" "gke-admin-vm-admins-clusters" {
  role    = "roles/container.admin"
  members = [
    "serviceAccount:${google_service_account.gke-admin-vm.email}"
  ]
}


