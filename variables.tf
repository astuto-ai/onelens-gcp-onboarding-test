# -----------------------------------------------------------------------------
# INPUT VARIABLES
# -----------------------------------------------------------------------------

variable "finops_service_account_id" {
  type        = string
  description = "A unique ID for the service account to be created (e.g., 'finops-reader-tool'). Only used if 'existing_finops_service_account_email' is null."
  default     = null
}

variable "existing_finops_service_account_email" {
  type        = string
  description = "Optional. The full email address of an existing service account. If provided, the script will use this SA instead of creating a new one."
  default     = null
}

variable "target_project_ids" {
  type        = list(string)
  description = "A list of GCP Project IDs that the service account needs to monitor. All project-level roles will be applied here."
}

variable "target_billing_account_id" {
  type        = string
  description = "The ID of the customer's GCP Billing Account. Sample value '01A2BC-34D5E6-F7G8H9'."
}

variable "target_organization_id" {
  type        = string
  description = "The ID of the customer's GCP Organization (e.g., '123456789012') to grant hierarchy visibility."
}

variable "target_folder_id" {
  type        = string
  description = "Optional. The ID of a specific GCP Folder (e.g., '123456789012') to scope viewer permissions. If left null, permissions are applied at the organization level."
  default     = null
}

variable "billing_export_project_id" {
  type        = string
  description = "The Project ID where billing data is exported to a BigQuery dataset. Required for detailed cost analysis."
}

variable "create_billing_export_project" {
  type        = bool
  description = "Set to true to create the billing export project. If false, the script assumes the project already exists."
  default     = false
}

variable "enable_appengine_viewer" {
  type        = bool
  description = "Set to true to apply the 'roles/appengine.viewer' role. The target project(s) MUST have an App Engine application initialized for this to succeed."
  default     = false
}
