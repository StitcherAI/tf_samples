terraform {
  required_version = ">= 1.3.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  # Authentication is taken from the environment (e.g. `gcloud auth application-default login`
  # or the GOOGLE_APPLICATION_CREDENTIALS env var). See README for prerequisites.
}
