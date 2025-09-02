# This file defines the reusable module.
# It accepts three input variables from the main.tf file.
variable "project_id" {
  type        = string
  description = "The project to apply the IAM roles to."
}

variable "finops_service_account_email" {
  type        = string
  description = "The service account that will be granted the roles."
}

variable "roles" {
  type        = list(string)
  description = "The list of IAM roles to grant to the service account."
}

# This is the core logic. It loops through the "roles" variable
# and creates an IAM binding for each one on the specified project.
resource "google_project_iam_member" "project_bindings" {
  for_each = toset(var.roles)
  project  = var.project_id
  role     = each.key
  member   = "serviceAccount:${var.finops_service_account_email}"
}
