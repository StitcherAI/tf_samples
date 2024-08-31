provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}


# This module creates an Azure AD application/client/tenant infrastructure used to grant access to relevant Azure 
# resources (cost or business datasets OR export locations) on a customer environemnt. Access to StitcherAI is granted
# via an AD application to avoid needing to provide StitcherAI with customer credentials.
# Notes: 
# * Customers can chose to create different AD principals for different access granting scenarios (e.g. separate read
# and write access within a single Azure environment).
# * StitcherAI terraform modules are available at github.com:StitcherAI/tf-modules.git (public)

# The below example simulates a customer granting StitcherAI access to their Azure environemnt for the following needs:
# Need 1. Extracting Azure cost extract from an Azure storage account
# Need 2. Extracting business datasets stored in an Azure storage account
# Need 3. Exporting StitcherAI data to Azure storage account (example illustrates using the same AD principal)



# *********************************************************************************************************************
# Step 0. Create AD principal to provide read/write access to specific locations

# This module is used to create an Azure AD application and assign necessary permissions to it
# We can create multiple applications for different purposes, such as reading business datasets or exporting data to Azure Blob Store
# For each application, we need to provide the environment_id and stitcher_ai_sa_id
# For each application, we will get the client_id and tenant_id as outputs

module "azure_ad_application" {
  source = "git@github.com:StitcherAI/tf-modules.git//azure/ad-application"

  workload_identity_display_name = var.workload_identity_display_name
  environment_id    = var.stitcherai_environment_id
  stitcher_ai_sa_id = var.stitcher_ai_service_account_id
}

# This value is needed when configuring data sources/destinations on the web app
output "stitcher_ai_app_client_id" {
  value = module.azure_ad_application.stitcher_ai_app_client_id

  description = "Value of the client id of the StitcherAI application, this needs to be configured while creating data sources"
}

# This value is needed when configuring data sources/destinations on the web app
output "azure_tenant_id" {
  value = module.azure_ad_application.azure_tenant_id

  description = "Value of the tenant id of the Azure AD tenant, this needs to be configured while creating data sources"
}


# *********************************************************************************************************************
# Need 1. Extracting Azure cost extract from an Azure storage account
# Description: Azure access policies needed for extracting cost data. Includes read-only access to the storage account
# bucket/path where the cost data files are stored. These policies are attached to the azure_principal_id created above.

# This module is used to grant access to extract data from Azure Blob Store
module "azure_cost_extract" {
  source = "git@github.com:StitcherAI/tf-modules.git//azure/blob-store-extract"

  stitcher_ai_service_principal_id = module.azure_ad_application.azure_principal_id
  storage_account_name             = var.storage_account_name
  storage_container_name           = var.read_storage_container_name
  blob_path                        = var.cost_data_path
  resource_group_name              = var.resource_group_name
}



# *********************************************************************************************************************
# Need 2. Extracting business datasets stored in an Azure storage account
# Description: Azure access policies needed for extracting business data. Includes read-only access to the storage account
# bucket/path where the cost data files are stored. These policies are attached to the azure_principal_id created above.

# This module is used to grant access to extract data from Azure Blob Store
module "azure_business_data_extract" {
  source = "git@github.com:StitcherAI/tf-modules.git//azure/blob-store-extract"

  stitcher_ai_service_principal_id = module.azure_ad_application.azure_principal_id
  storage_account_name             = var.storage_account_name
  storage_container_name           = var.read_storage_container_name
  blob_path                        = var.business_data_path
  resource_group_name              = var.resource_group_name
}




# *********************************************************************************************************************
# Need 3. Exporting StitcherAI data to Azure storage account (example illustrates using the same AD principal)
# Description: Azure access policies needed for exporting StitcherAI data. Includes write access to the storage account
# bucket/path where the cost data files are stored. These policies are attached to the azure_principal_id created above.

# This module is used to export data to Azure Blob Store
module "azure_blob_store_export" {
  source = "git@github.com:StitcherAI/tf-modules.git//azure/blob-store-export"

  stitcher_ai_service_principal_id = module.azure_ad_application.azure_principal_id
  storage_account_name             = var.storage_account_name
  storage_container_name           = var.write_storage_container_name
  blob_path                        = var.stitcherai_write_path
  resource_group_name              = var.resource_group_name
}
