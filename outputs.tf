output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

output "admin_access" {
  value       = "gcloud beta compute ssh --zone ${var.zone} ${google_compute_instance.vm_instance.name} --project ${var.project_id}"
  description = "Get access to the vm that manages the cluster"
}

output "vulnerable-example-com" {
  value       = "https://console.cloud.google.com/kubernetes/deployment/${var.zone}/${google_container_cluster.primary.name}/default/vulnerable.example.com/overview?project=${var.project_id}"
  description = "Link to vulnerable.example.com deployment. May take a few moments to come up"
}
