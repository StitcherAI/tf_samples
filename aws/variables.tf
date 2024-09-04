variable "stitcher_ai_aws_account_id" {
  description = "The StitcherAI AWS account id. (Provided by StitcherAI)"
  type    = string
}

variable "stitcherai_environment_id" {
  description = "The StitcherAI environment id. (Provided by StitcherAI)"
  type        = string
}

variable "read_iam_role_name" {
  description = "The name of the read role to create in the customer AWS environment."
  type = string
}

variable "read_external_id" {
  description = "External ID for the read role to enhance security, as recommended by AWS IAM."
  type        = string
}

variable "write_iam_role_name" {
  description = "The name of the write role to create in the customer AWS environment."
  type = string
}

variable "write_external_id" {
  description = "External ID for the write role to enhance security, as recommended by AWS IAM."
  type        = string
}

variable "stitcher_ai_s3_read_bucket" {
  description = "S3 bucket where the CUR and business datasets are read from."
  type        = string
}

variable "cur_s3_path" {
  description = "S3 path where the CUR is stored. (Optional)"
  type        = string
  nullable  = true
}

variable "business_data_s3_path" {
  description = "S3 path where the CUR is stored. (Optional)"
  type        = string
  nullable  = true
}

variable "stitcher_ai_s3_write_bucket" {
  description = "S3 bucket where the StitcherAI datasets are exported to."
  type        = string
}

variable "s3_write_path" {
  description = "S3 path where the data-writes are done. (Optional)"
  type        = string
  nullable  = true
}