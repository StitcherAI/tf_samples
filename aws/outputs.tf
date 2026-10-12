# After `terraform apply`, hand these role ARNs back to StitcherAI so it can assume them.
# (Use the ARN, not the role name, when configuring the StitcherAI web app.)

output "read_role_arn" {
  description = "ARN of the read role StitcherAI assumes to extract CUR and business datasets."
  value       = module.read_iam_role.stitcher_ai_role_arn
}

output "write_role_arn" {
  description = "ARN of the write role StitcherAI assumes to export processed data."
  value       = module.write_iam_role.stitcher_ai_role_arn
}
