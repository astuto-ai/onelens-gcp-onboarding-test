# -----------------------------------------------------------------------------
# SERVICE ACCOUNT CREATION (CONDITIONAL)
# -----------------------------------------------------------------------------
# Creates a new service account only if an existing one is not provided.
resource "google_service_account" "finops_sa" {
  count = var.existing_finops_service_account_email == null ? 1 : 0

  account_id   = var.finops_service_account_id
  display_name = "OneLens Reader Service Account"
  project      = var.target_project_ids[0] # Creates the SA in the first project in the list
}

# -----------------------------------------------------------------------------
# BILLING EXPORT PROJECT CREATION (CONDITIONAL)
# -----------------------------------------------------------------------------
resource "google_project" "billing_export" {
  count = var.create_billing_export_project ? 1 : 0

  name       = var.billing_export_project_id
  project_id = var.billing_export_project_id
  org_id     = var.target_organization_id
}

resource "google_project_service" "billing_export_apis" {
  for_each = var.create_billing_export_project ? toset([
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "billingbudgets.googleapis.com",
    "bigquery.googleapis.com",
    "cloudbilling.googleapis.com"
  ]) : []

  project            = google_project.billing_export[0].project_id
  service            = each.key
  disable_on_destroy = false
}

# -----------------------------------------------------------------------------
# IAM ROLE BINDINGS
# -----------------------------------------------------------------------------

locals {
  # Determine which service account email to use: the newly created one or an existing one.
  finops_sa_email = var.existing_finops_service_account_email == null ? google_service_account.finops_sa[0].email : var.existing_finops_service_account_email

  billing_project_id = var.create_billing_export_project ? google_project.billing_export[0].project_id : var.billing_export_project_id

  # These roles are applied at either the Folder or Organization level.
  folder_or_org_roles = [
    "roles/resourcemanager.organizationViewer",
    "roles/resourcemanager.folderViewer",
    "roles/cloudasset.viewer"
  ]

  # Base list of project-level roles.
  base_project_roles = [
    "roles/aiplatform.viewer",
    "roles/artifactregistry.reader",
    "roles/bigquery.dataViewer",
    "roles/bigtable.reader",
    "roles/cloudfunctions.viewer",
    "roles/cloudsql.viewer",
    "roles/compute.viewer",
    "roles/container.viewer",
    "roles/dataflow.viewer",
    "roles/dataproc.viewer",
    "roles/datastore.viewer",
    "roles/file.viewer",
    "roles/logging.viewer",
    "roles/monitoring.viewer",
    "roles/networkmanagement.viewer",
    "roles/pubsub.viewer",
    "roles/recommender.viewer",
    "roles/redis.viewer",
    "roles/run.viewer",
    "roles/serviceusage.serviceUsageViewer",
    "roles/spanner.viewer",
    "roles/storage.viewer"
  ]

  # List of APIs corresponding to the roles above.
  required_project_apis = [
    "aiplatform.googleapis.com",
    "artifactregistry.googleapis.com",
    "bigquery.googleapis.com",
    "bigtable.googleapis.com",
    "cloudasset.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudfunctions.googleapis.com",
    "sqladmin.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "dataflow.googleapis.com",
    "dataproc.googleapis.com",
    "datastore.googleapis.com",
    "file.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "networkmanagement.googleapis.com",
    "pubsub.googleapis.com",
    "recommender.googleapis.com",
    "redis.googleapis.com",
    "run.googleapis.com",
    "serviceusage.googleapis.com",
    "spanner.googleapis.com",
    "storage.googleapis.com"
  ]
}

# --- Enable APIs on all Target Projects ---
resource "google_project_service" "target_project_apis" {
  for_each = toset(flatten([
    for project in var.target_project_ids : [
      for api in local.required_project_apis :
      "${project}/${api}"
    ]
  ]))

  project            = split("/", each.key)[0]
  service            = split("/", each.key)[1]
  disable_on_destroy = false
}

# --- Billing Account Level Role ---
resource "google_billing_account_iam_member" "billing_viewer" {
  billing_account_id = var.target_billing_account_id
  role               = "roles/billing.viewer"
  member             = "serviceAccount:${local.finops_sa_email}"
}

# --- Organization Level Roles (Conditional) ---
resource "google_organization_iam_member" "org_bindings" {
  for_each = var.target_folder_id == null ? toset(local.folder_or_org_roles) : toset([])
  org_id   = var.target_organization_id
  role     = each.key
  member   = "serviceAccount:${local.finops_sa_email}"
}

# --- Folder Level Roles (Conditional) ---
resource "google_folder_iam_member" "folder_bindings" {
  for_each = var.target_folder_id != null ? toset(local.folder_or_org_roles) : toset([])
  folder   = "folders/${var.target_folder_id}"
  role     = each.key
  member   = "serviceAccount:${local.finops_sa_email}"
}

# --- BigQuery Billing Export Roles ---
resource "google_project_iam_member" "bigquery_billing_export_bindings" {
  for_each = toset(var.billing_export_project_id != null ? ["roles/bigquery.jobUser", "roles/bigquery.dataViewer"] : [])
  project  = local.billing_project_id
  role     = each.key
  member   = "serviceAccount:${local.finops_sa_email}"
  depends_on = [google_project.billing_export]
}

# --- Project Level Roles (Base) ---
module "project_iam_bindings" {
  source   = "./modules/project_iam"
  for_each = toset(var.target_project_ids)

  project_id                   = each.key
  finops_service_account_email = local.finops_sa_email
  roles                        = local.base_project_roles
  depends_on = [
    google_project_service.target_project_apis
  ]
}

# --- Conditional App Engine Role ---
resource "google_project_iam_member" "appengine_viewer_binding" {
  for_each = toset(var.enable_appengine_viewer ? var.target_project_ids : [])

  project = each.key
  role    = "roles/appengine.viewer"
  member  = "serviceAccount:${local.finops_sa_email}"
}

