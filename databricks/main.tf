# This module creates Databricks access for StitcherAI to read Databricks billing and usage data on a customer
# environment. Access is granted via a dedicated Databricks service principal with read-only access to the Databricks
# system tables, plus a SQL warehouse to run queries on.
# Notes:
# * Terraform authenticates to Databricks as an admin identity through two Databricks CLI profiles you create with
# `databricks auth login`: one for the workspace and one for the account console. Your admin credentials stay in the
# CLI profiles and never pass through Terraform. The StitcherAI service principal secret is an output, so it is stored
# in Terraform state; protect the state accordingly.
# * StitcherAI terraform modules are available at github.com:StitcherAI/tf-modules.git (public)

# The below example simulates a customer granting StitcherAI access to their Databricks environment for the following
# needs:
# Need 1. Extracting Databricks billing and usage data


# *********************************************************************************************************************
# Need 1. Extracting Databricks billing and usage data
# Description: Creates the StitcherAI service principal and an OAuth secret for it, and a SQL warehouse the principal can
# use. The principal is granted USE_CATALOG on the system catalog, USE_SCHEMA/SELECT on the system.billing,
# system.compute, and system.lakeflow schemas, and USE_SCHEMA on system.access with SELECT on
# system.access.workspaces_latest only. Creating the service principal and warehouse requires the Terraform identity to
# be a workspace admin, and granting on the system schemas requires it to be a metastore admin.

module "databricks_read_access" {
  source = "git::https://github.com/StitcherAI/tf-modules.git//databricks/read-access"

  workspace_profile = var.workspace_profile
  account_profile   = var.account_profile

  sql_warehouse_size = var.sql_warehouse_size
}
