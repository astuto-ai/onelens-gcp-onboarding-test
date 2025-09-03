# --- Service Account Configuration ---

# Create a new service account ur use an existing one
# Provide an ID for the new service account and leave the 'existing_finops_service_account_email' commented out or null.
# finops_service_account_id = null
existing_finops_service_account_email = "fawaz-test1-integration@astuto-test-mum.iam.gserviceaccount.com"


# --- Target GCP Resources ---
target_project_ids = [
  "astuto-test-mum"
]

target_billing_account_id = "018F24-AE226D-4C8CCC"
target_organization_id    = "985833232516"

# Optional: To apply viewer roles to a specific folder, uncomment and set the folder ID.
# Otherwise, roles are applied at the organization level.
# target_folder_id = "234567890123"

# --- Billing Export Project ---
billing_export_project_id   = "billing-export-468711"
create_billing_export_project = false

# --- Conditional Roles ---
# Set to true only if the target projects have App Engine initialized.
enable_appengine_viewer = false
