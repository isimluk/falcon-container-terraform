resource "google_compute_instance" "vm_instance" {
  name         = "gke_admin_vm"
  machine_type = "f1-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {
    }
  }

  metadata_startup_script = file("gke_admin_vm.sh")
}
