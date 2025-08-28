# DynamoDB Backend Module - Outputs
# This file defines all outputs from the DynamoDB backend module

output "table_name" {
  description = "Name of the DynamoDB table for Terraform state locking"
  value       = aws_dynamodb_table.terraform_locks.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table for Terraform state locking"
  value       = aws_dynamodb_table.terraform_locks.arn
}

output "table_region" {
  description = "Region of the DynamoDB table for Terraform state locking"
  value       = data.aws_region.current.name
}

output "table_id" {
  description = "ID of the DynamoDB table for Terraform state locking"
  value       = aws_dynamodb_table.terraform_locks.id
}
