# DynamoDB Backend Module - Main Configuration
# This file creates a DynamoDB table for Terraform state locking

# Data source for current AWS region
data "aws_region" "current" {}

# DynamoDB table for Terraform state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  tags = merge(
    var.tags,
    {
      Name        = "Terraform State Locks"
      Environment = var.environment
      Purpose     = "Terraform State Locking"
      ManagedBy   = "Terraform"
    }
  )
}
