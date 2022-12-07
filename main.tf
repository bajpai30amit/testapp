terraform {
  required_version = ">=0.13"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.29.0, < 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.10"
    }
    
  }


resource "google_service_account" "custom_service_account" {
  account_id   = "my-account"
  display_name = "Custom Service Account"
}

resource "google_project_iam_member" "gae_api" {
  project = google_service_account.custom_service_account.project
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:tf-test@shoptrue-gke.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "storage_viewer" {
  project = google_service_account.custom_service_account.project
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:tf-test@shoptrue-gke.iam.gserviceaccount.com"
}

resource "google_app_engine_standard_app_version" "myapp_v1" {
  version_id = "v1"
  service    = "myapp"
  runtime    = "nodejs10"

  entrypoint {
    shell = "node ./app.js"
  }

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/${google_storage_bucket_object.object.name}"
    }
  }

  env_variables = {
    port = "8080"
  }

  automatic_scaling {
    max_concurrent_requests = 10
    min_idle_instances = 1
    max_idle_instances = 3
    min_pending_latency = "1s"
    max_pending_latency = "5s"
    standard_scheduler_settings {
      target_cpu_utilization = 0.5
      target_throughput_utilization = 0.75
      min_instances = 2
      max_instances = 10
    }
  }

  delete_service_on_destroy = true
  service_account = tf-test@shoptrue-gke.iam.gserviceaccount.com
}

resource "google_app_engine_standard_app_version" "myapp_v2" {
  version_id      = "v2"
  service         = "myapp"
  runtime         = "nodejs10"
  app_engine_apis = true

  entrypoint {
    shell = "node ./app.js"
  }

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/${google_storage_bucket_object.object.name}"
    }
  }

  env_variables = {
    port = "8080"
  }

  basic_scaling {
    max_instances = 5
  }

  noop_on_destroy = true
  service_account = tf-test@shoptrue-gke.iam.gserviceaccount.com
}

resource "google_storage_bucket" "bucket" {
  name     = "appengine-static-content"
  location = "US"
}

resource "google_storage_bucket_object" "object" {
  name   = "hello-world.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./test-fixtures/appengine/hello-world.zip"
