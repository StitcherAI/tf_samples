variable "stitcher_environment_id" {
  type        = string
  description = "The StitcherAI environment id."
}

variable "gcp_domain" {
  description = "(Optional) The gcp domain for the Stitcher AI service."
  type        = string
  default     = null
}

variable "gcp_project_id" {
  description = "The GCP project id where the resources read or written are provisioned"
  type        = string
}

variable "cost_extract_dataset_id" {
  description = "The BigQuery dataset where the GCP Billing data is extracted from"
  type        = string
}

variable "business_data_bucket" {
  description = "The GCS bucket where the business data is extracted from"
  type        = string
}

variable "business_data_path" {
  description = "The path within the GCS bucket where the business data is extracted from"
  type        = string
}

variable "export_dataset_id" {
  description = "The BigQuery dataset where the StitcherAI data is exported to"
  type        = string
}

variable "export_data_bucket" {
  description = "The GCS bucket where the StitcherAI data is exported to"
  type        = string
}

variable "export_data_path" {
  description = "The path within the GCS bucket where the StitcherAI data is exported to"
  type        = string
}