# -----------------------------------------------------------------------------
# INPUT VARIABLES
# -----------------------------------------------------------------------------

variable "finops_service_account_id" {
  type        = string
  description = "The desired ID for the OneLens Reader service account (e.g., 'OneLens-reader'). This will be created by Terraform."
}

variable "target_project_ids" {
  type        = list(string)
  description = "A list of GCP Project IDs that the service account needs to monitor. All project-level roles will be applied here. The service account will be created in the first project of this list."
}

variable "target_organization_id" {
  type        = string
  description = "The ID of the customer's GCP Organization (e.g., '123456789012') to grant hierarchy visibility."
}

variable "billing_export_project_id" {
  type        = string
  description = "The Project ID where billing data is exported to a BigQuery dataset. Required for detailed cost analysis. If 'create_billing_export_project' is true, this will be the ID of the new project."
}

variable "create_billing_export_project" {
  type        = bool
  description = "Set to true to create a new project for billing export. If false, it assumes the 'billing_export_project_id' already exists."
  default     = true
}

variable "enable_appengine_viewer" {
  type        = bool
  description = "Set to true to attempt to grant the App Engine Viewer role to projects that have the App Engine API enabled."
  default     = true
}