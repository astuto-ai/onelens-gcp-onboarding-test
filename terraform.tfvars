# The desired ID for the OneLens Reader service account.
finops_service_account_id = "fawaz-test"

# A list of the customer's projects to monitor.
target_project_ids = [
  "astuto-test-mum"
]

# The customer's organization ID for hierarchy viewing.
target_organization_id = "985833232516" # e.g. "123456789012"

# The project where billing is exported to BigQuery.
# If create_billing_export_project is true, a new project with this ID will be created.
billing_export_project_id = "billing-export-468711"

# Set to true if you want Terraform to create the billing export project for you.
# Make sure the user/SA running terraform has permissions to create projects.
create_billing_export_project = false

# Set to true if you want Terraform to attempt to grant the App Engine Viewer role to projects that have the App Engine API enabled.
enable_appengine_viewer = false