# After `terraform apply`, enter these values in the StitcherAI web app when creating the Databricks data source.
# Read the secret with `terraform output -raw stitcherai_client_secret`. The data source also asks for the Account ID
# and Host URL: use the account id and workspace URL you passed to `databricks auth login`.

output "stitcherai_client_id" {
  description = "OAuth client ID: the application id of the StitcherAI service principal."
  value       = module.databricks_read_access.stitcherai_client_id
}

output "stitcherai_client_secret" {
  description = "OAuth client secret generated for the StitcherAI service principal."
  value       = module.databricks_read_access.stitcherai_client_secret
  sensitive   = true
}

output "stitcherai_warehouse_id" {
  description = "SQL warehouse ID StitcherAI runs billing queries on."
  value       = module.databricks_read_access.stitcherai_warehouse_id
}
