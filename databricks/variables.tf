variable "workspace_profile" {
  description = "Databricks CLI profile for the target workspace, created with `databricks auth login --host <WORKSPACE-URL> --profile <NAME>`."
  type        = string
  default     = "stitcherai-workspace"
}

variable "account_profile" {
  description = "Databricks CLI profile for the account console, created with `databricks auth login --host <ACCOUNT-CONSOLE-URL> --account-id <ACCOUNT-ID> --profile <NAME>`."
  type        = string
  default     = "stitcherai-account"
}

variable "sql_warehouse_size" {
  description = "Cluster size of the SQL warehouse StitcherAI queries with."
  type        = string
  default     = "2X-Small"
}
