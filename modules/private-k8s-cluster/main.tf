resource "random_string" "identifier" {
  length           = 5
  special          = true
  upper            = true
  lower            = true
  numeric          = true
  override_special = "123456789"
}

resource "google_service_account" "default" {
  account_id   = "k8s-sa-${random_string.identifier.result}"
  display_name = "Node pool service account"
}

resource "google_project_iam_member" "service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:k8s-sa-${random_string.identifier.result}@${var.project_id}.iam.gserviceaccount.com"
}


resource "google_container_cluster" "gke_cluster" {
  name       = var.cluster_name
  location   = var.region
  network    = var.network_name
  subnetwork = var.subnet_name

  release_channel {
    channel = "RAPID"
  }

  # network_policy {
  #   enabled = true
  # }

  resource_labels = {
    "project" = "crossing-the-narrow-bridge"
  }

  enable_intranode_visibility = true

  cluster_autoscaling {
    enabled = true
    resource_limits {
      maximum       = var.cluster_autoscaling_max_memory_gb
      resource_type = "memory"
    }
    resource_limits {
      maximum       = var.cluster_autoscaling_max_cpu
      resource_type = "cpu"
    }
  }

  vertical_pod_autoscaling {
    enabled = true
  }

  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_cidr_blocks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  binary_authorization {
    evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

# Node pool for GKE Cluster
resource "google_container_node_pool" "gke_nodes" {
  for_each = { for idx, pool in var.node_pools : pool.name => pool }

  name     = each.value["name"]
  location = var.region
  cluster  = var.cluster_name

  management {
    auto_upgrade = true
    auto_repair  = true
  }

  autoscaling {
    total_min_node_count = each.value["total_min_node_count"]
    total_max_node_count = each.value["total_max_node_count"]
  }

  node_config {
    machine_type    = each.value["node_machine_type"]
    disk_size_gb    = each.value["node_disk_size_gb"]
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    service_account = google_service_account.default.email
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    labels = {
      "env" = "test"
    }
  }

  depends_on = [google_container_cluster.gke_cluster]
  lifecycle {
    ignore_changes = [node_config]
  }
}

# Create jump host to access private k8s cluster
resource "google_compute_address" "my_internal_ip_addr" {
  project      = var.project_id
  address_type = "INTERNAL"
  region       = var.region
  subnetwork   = var.subnet_name
  name         = var.jump_host_ip_address_name
  address      = var.jump_host_ip_address
  description  = "An internal IP address for jump host"
}

resource "google_compute_instance" "default" {
  project      = var.project_id
  zone         = "${var.region}-b"
  name         = var.jump_host_name
  machine_type = "custom-2-15360-ext"

  allow_stopping_for_update = true

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_name # Replace with a reference or self link to your subnet, in quotes
    network_ip = google_compute_address.my_internal_ip_addr.address
  }

  metadata = {
    block-project-ssh-keys = "true"
  }
}


## Create Firewall to access jump host via iap
resource "google_compute_firewall" "rules" {
  project = var.project_id
  name    = "allow-ssh"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  # Fixed IAP source range
  source_ranges = ["35.235.240.0/20"]
}

resource "google_service_account" "jump_host" {
  account_id   = "jump-host-sa-${random_string.identifier.result}"
  display_name = "Jump host service account"
}

## Create IAP SSH permissions for your test instance
resource "google_project_iam_member" "project" {
  project = var.project_id
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "serviceAccount:${google_service_account.jump_host.email}"
}

# create cloud router for nat gateway
resource "google_compute_router" "router" {
  project = var.project_id
  name    = "nat-router"
  network = var.network_name
  region  = var.region
}

# NOTE: It is recommended to use the Cloud Router module instead of this module.
# The Cloud Router module is more flexible and can be used to manage resources in
# addition to NATs such as interconnects.
module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 5.3.0"
  project_id = var.project_id
  region     = var.region
  router     = google_compute_router.router.name
  name       = "nat-config"
}
