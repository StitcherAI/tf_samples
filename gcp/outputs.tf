# GCP access is granted directly to the StitcherAI service account (provided by StitcherAI), so there are
# no new credentials to hand back. These outputs simply confirm what was granted, for your records and for
# cross-checking against the values configured in the StitcherAI web app.

output "stitcher_ai_sa_email" {
  description = "The StitcherAI service account the grants were applied to."
  value       = var.stitcher_ai_sa_email
}

output "gcp_project_id" {
  description = "The GCP project the grants were applied to."
  value       = var.gcp_project_id
}

output "gcs_bucket_list_role_id" {
  description = "The custom role that lets the StitcherAI service account list objects in the configured buckets."
  value       = module.gcs_bucket_list_role.bucket_list_role_id
}
