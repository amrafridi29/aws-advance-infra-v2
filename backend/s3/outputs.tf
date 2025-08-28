# S3 Backend Module - Outputs
# This file defines all outputs from the S3 backend module

output "bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.arn
}

output "bucket_region" {
  description = "Region of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.region
}

output "bucket_id" {
  description = "ID of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}
