# --- Service Account Configuration ---

# Create a new service account or use an existing one
finops_service_account_id = "abc123"
# existing_finops_service_account_email = null


# --- Target GCP Resources ---
target_project_ids = [
  "proj1"
]

target_billing_account_id = "ABCDEFG-HIJKLMO-123456"
target_organization_id    = "111111222222"

# Optional: To apply viewer roles to a specific folder, uncomment and set the folder ID.
# Otherwise, roles are applied at the organization level.
# target_folder_id = "234567890123"

# --- Billing Export Project ---
billing_export_project_id   = "billing-project-12345"
create_billing_export_project = true

# --- Conditional Roles ---
# Set to true only if the target projects have App Engine initialized.
enable_appengine_viewer = false
