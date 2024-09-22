terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.19.0"
    }
  }
}

#Configure the Google Cloud provider
provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = "/path-to-the-sa-json-key.json"
}

#Create a GCS bucket
resource "google_storage_bucket" "project_bucket" {
  name     = var.bucket_name
  location = var.region
}

#Upload AIS data files to the bucket
resource "google_storage_bucket_object" "AIS_data" {
  for_each = { for file in var.ais_files : file.name => file }

  name   = each.key
  bucket = google_storage_bucket.project_bucket.name
  source = each.value.source
}

#Create a BigQuery dataset
resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.dataset_id
  location    = var.region
}

#Create a BigQuery table for ship data
resource "google_bigquery_table" "ships" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = var.table_ships
  schema     = var.table_schema
}

#Create a BigQuery table for filtered data
resource "google_bigquery_table" "filtered_data" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = var.table_filtered
  schema     = var.table_schema
}

#Create an external IP address
resource "google_compute_address" "external_ip" {
  name         = var.external_ip_name
  address_type = "EXTERNAL"
  project      = var.project_id
  region       = var.region
}

#Create a VM instance
resource "google_compute_instance" "main" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image_name
    }
  }

  network_interface {
    subnetwork         = "projects/${var.project_id}/regions/${var.region}/subnetworks/${var.subnetwork_name}"
    subnetwork_project = var.project_id
    access_config {
      nat_ip = google_compute_address.external_ip.address
    }
  }
}

#Create a firewall rule to allow traffic on port 8080
resource "google_compute_firewall" "airflow_firewall" {
  name    = var.airflow_firewall_name
  network = "projects/${var.project_id}/global/networks/default"
  
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  
  source_ranges = ["0.0.0.0/0"] #Allow from anywhere (adjust as needed for security)
}
