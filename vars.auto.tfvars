# --- Service Account Configuration ---

finops_service_account_id = "enter-new-sa-id-here"
# existing_finops_service_account_email = "enter-existing-sa-email-here"

# --- Target GCP Resources ---
# Replace these with actual IDs in the Infrastructure Manager UI.
target_project_ids = [
  "enter-project-id-1-here",
  "enter-project-id-2-here"
]
target_billing_account_id = "000000-000000-000000"
target_organization_id    = "000000000000"

# --- Optional Folder ID ---
# Only set this if you are scoping permissions to a specific folder.
# target_folder_id = "000000000000"

# --- Billing Export Project ---
billing_export_project_id   = "billing-export-project-id"
create_billing_export_project = true

# --- Conditional Roles ---
# Set to true only if App Engine is used in the target projects.
enable_appengine_viewer = false
