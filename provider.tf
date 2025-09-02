# -----------------------------------------------------------------------------
# TERRAFORM & PROVIDER CONFIGURATION
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# The provider configuration assumes the user is authenticated via the
# gcloud CLI or by setting the GOOGLE_CREDENTIALS environment variable.
provider "google" {}
