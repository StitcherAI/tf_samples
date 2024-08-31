variable "subscription_id" {
  description = "The Azure subscription id."
  type        = string
}

variable "workload_identity_display_name" {
  description = "The display name used for the workload identity app and credential."
  type        = string
}

variable "stitcherai_environment_id" {
  description = "The StitcherAI environment id. (Provided by StitcherAI)"
  type        = string
}

variable "stitcher_ai_service_account_id" {
  description = <<EOT
    The ID of the service account for the StitcherAI environment, this grants stitcher sa access to the configured resources. 
    (Provided by StitcherAI)
  EOT
  type = string
}

variable "resource_group_name" {
  description = "The resource group name in Azure where the storage account is located."
  type        = string
}

variable "storage_account_name" {
  description = "The storage account in Azure where StitcherAI will read/write data from/to."
  type        = string
}

variable "read_storage_container_name" {
  description = "The storage container in Azure where StitcherAI will read data from."
  type        = string
}

variable "cost_data_path" {
  description = "The path in Azure storage where StitcherAI will read cost data from."
  type        = string
}

variable "business_data_path" {
  description = "The path in Azure storage where StitcherAI will read business data from."
  type        = string
}

variable "write_storage_container_name" {
  description = "The storage container in Azure where StitcherAI will write data to."
  type        = string
}

variable "stitcherai_write_path" {
  description = "The path in Azure storage where StitcherAI will write StitcherAI datasets to."
  type        = string
}