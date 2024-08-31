# This module creates an IAM role which is used to grant access to relevant AWS resources (cost or business datasets OR
# export locations) on a customer environemnt. Access is granted to StitcherAI via IAM role assumption (recommended
# cross account access granting mechanism per AWS). 
# Notes: 
# * Customers can chose to create different roles for different access granting scenarios (e.g. separate read and 
# write roles within a single AWS account).
# * StitcherAI terraform modules are available at github.com:StitcherAI/tf-modules.git (public)

# The below example simulates a customer granting StitcherAI access to their AWS account for the following needs:
# Need 1. Extracting AWS Cost and Usage Report (CUR) data from an S3 bucket
# Need 2. Extracting business datasets stored in an AWS S3 bucket
# Need 3. Exporting StitcherAI data to an S3 bucket (example illustrates using a separate role - it is not necessary)



# *********************************************************************************************************************
# Step 0. Create two roles - one to provide read access to StitcherAI and another for write access grants (as 
# mentioned above a customer may chose to create a single role for both scenarios as well)

module "read_iam_role" {
  source         = "git@github.com:StitcherAI/tf-modules.git//aws/iam-role"
  environment_id = var.stitcher_ai_environment_id
  external_id    = var.stitcher_ai_aws_account_id

  stitcher_ai_aws_account_id = var.stitcher_ai_aws_account_id

  iam_role_name = var.read_iam_role_name # User-defined IAM role name (e.g. stitcher-ai-role) from tfvars file
}

module "write_iam_role" {
  source         = "git@github.com:StitcherAI/tf-modules.git//aws/iam-role"
  environment_id = var.stitcher_ai_environment_id
  external_id    = var.write_external_id

  stitcher_ai_aws_account_id = var.stitcher_ai_aws_account_id

  iam_role_name = var.write_iam_role_name # User-defined IAM role name (e.g. stitcher-ai-role) from tfvars file
}



# *********************************************************************************************************************
# Need 1. Extracting AWS Cost and Usage Report (CUR) data from an S3 bucket
# Description: IAM access policies needed for extracting CUR data includes read-only access to the CUR API and s3
# bucket/path where the CUR files are stored. These policies are attached to the read IAM role created above.

# CUR API read access (aws/cur-describe-policy)
module "cur_describe_policy" {
  source = "git@github.com:StitcherAI/tf-modules.git//aws/cur-describe-policy"

  stitcher_ai_role = module.read_iam_role.stitcher_ai_role
}

# S3 read and list API access for configured bucket/path (s3-extract-policy)
module "cur_extract_policy" {
  source    = "git@github.com:StitcherAI/tf-modules.git//aws/s3-extract-policy"
  s3_bucket = var.stitcher_ai_s3_read_bucket
  s3_path   = var.cur_s3_path

  stitcher_ai_role = module.read_iam_role.stitcher_ai_role
}



# *********************************************************************************************************************
# Need 2. Extracting business datasets stored in an AWS S3 bucket
# Description: IAM access policies needed for extracting data from AWS S3 includes read-only access to the S3 
# bucket/path where the business datasets are stored. These policies are attached to the read IAM role created above.

# S3 read and list API access for configured bucket/path (s3-extract-policy)
module "s3_ref_extract_policy" {
  source    = "git@github.com:StitcherAI/tf-modules.git//aws/s3-extract-policy"
  s3_bucket = var.stitcher_ai_s3_read_bucket
  s3_path   = var.business_data_s3_path

  stitcher_ai_role = module.read_iam_role.stitcher_ai_role
}



# *********************************************************************************************************************
# Need 3. Exporting curated StitcherAI datasets to an AWS S3 bucket
# Description: Exporting data from StitcherAI to AWS S3 (e.g. parquet or CSV etc.) requires write access to the S3 
# bucket/path where a customer plans to consume the datasets. These policies are attached to the write IAM role above.

# S3 write and delete API access for configured bucket/path (s3-export-policy)
module "s3_export_policy" {
  source    = "git@github.com:StitcherAI/tf-modules.git//aws/s3-export-policy"
  s3_bucket = var.stitcher_ai_s3_write_bucket
  s3_path   = var.s3_write_path

  stitcher_ai_role = module.write_iam_role.stitcher_ai_role
}
