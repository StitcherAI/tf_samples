# This module creates GCP access grants for relevant GCP resources (cost or business datasets OR export locations) on a
# customer environment. Access is granted via a StitcherAI GCP service account (provided to customers per StitcherAI
# environment).
# Notes:
# * Simulates granting access to reads and writes on the same GCP Project. Customers can choose to use separate GCP
# projects for different data integrations based on where the resources reside.
# * StitcherAI terraform modules are available at github.com:StitcherAI/tf-modules.git (public)

# The below example simulates a customer granting StitcherAI access to their GCP resources for the following needs:
# Need 1. Extracting GCP cost extract from a BigQuery dataset
# Need 2. Extracting business datasets stored in a Google Cloud Storage (GCS) bucket
# Need 3. Exporting StitcherAI data to a GCS bucket and a BigQuery dataset


# *********************************************************************************************************************
# Shared: custom role that lets the StitcherAI service account list objects in the GCS buckets used by Needs 2 and 3.
# The GCS extract and export bindings look this role up by id, so it must exist before they run.

module "gcs_bucket_list_role" {
  source = "git::https://github.com/StitcherAI/tf-modules.git//gcp/iam-role/gcs"

  customer_gcp_project_id = var.gcp_project_id
}


# *********************************************************************************************************************
# Need 1. Extracting GCP cost extract from a BigQuery dataset
# Description: GCP access policies needed for extracting cost data from BigQuery. Includes read-only access to the
# dataset to view data and create jobs (for extract). This policy is attached to the StitcherAI GCP service account

# This module is used to grant access to extract data from a BigQuery dataset
module "bigquery_extract" {
  source = "git::https://github.com/StitcherAI/tf-modules.git//gcp/bigquery-extract-binding"

  stitcher_ai_sa_email              = var.stitcher_ai_sa_email
  customer_gcp_project_id           = var.gcp_project_id
  customer_bigquery_cost_dataset_id = var.cost_extract_dataset_id
}


# *********************************************************************************************************************
# Need 2. Extracting business datasets stored in a Google Cloud Storage (GCS) bucket
# Description: GCP access policies needed for extracting business data from GCS. Includes read-only access to the
# bucket/path where the business data files are stored. This policy is attached to the StitcherAI GCP service account

# This module is used to grant access to extract data from a GCS bucket
module "gcs_extract" {
  source = "git::https://github.com/StitcherAI/tf-modules.git//gcp/gcs-extract-binding"

  stitcher_ai_sa_email                 = var.stitcher_ai_sa_email
  customer_gcs_project_id              = var.gcp_project_id
  customer_gcs_bucket                  = var.business_data_bucket
  customer_gcs_path                    = var.business_data_path
  customer_gcp_gcs_bucket_list_role_id = module.gcs_bucket_list_role.bucket_list_role_id

  depends_on = [module.gcs_bucket_list_role]
}

# *********************************************************************************************************************
# Need 3. Exporting StitcherAI data to a GCS bucket and a BigQuery dataset
# Description: GCP access policies needed for exporting StitcherAI data. Includes write access to a BigQuery dataset
# and a bucket/path in GCS. These policies are attached to the StitcherAI GCP service account

# This module is used to grant access to export data into a BigQuery dataset
module "bigquery_export" {
  source = "git::https://github.com/StitcherAI/tf-modules.git//gcp/bigquery-export-binding"

  stitcher_ai_sa_email                = var.stitcher_ai_sa_email
  customer_gcp_project_id             = var.gcp_project_id
  customer_bigquery_export_dataset_id = var.export_dataset_id
}

# This module exports data to the configured GCS bucket/path.
module "gcs_export" {
  source = "git::https://github.com/StitcherAI/tf-modules.git//gcp/gcs-export-binding"

  stitcher_ai_sa_email                 = var.stitcher_ai_sa_email
  customer_gcs_project_id              = var.gcp_project_id
  customer_gcs_bucket                  = var.export_data_bucket
  customer_gcs_path                    = var.export_data_path
  customer_gcp_gcs_bucket_list_role_id = module.gcs_bucket_list_role.bucket_list_role_id

  depends_on = [module.gcs_bucket_list_role]
}
