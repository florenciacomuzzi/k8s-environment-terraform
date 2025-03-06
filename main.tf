resource "google_project_service" "compute_engine" {
  service = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_network" "vpc_network" {
  name = var.vpc_name
}