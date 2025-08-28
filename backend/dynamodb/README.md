# DynamoDB Backend Module

This module creates a DynamoDB table for Terraform state locking.

## 🎯 Purpose

- **State Locking**: Prevent concurrent modifications to Terraform state
- **Data Protection**: Point-in-time recovery enabled
- **Cost Optimization**: On-demand billing for flexibility
- **High Availability**: Built-in AWS availability and durability

## 🏗️ Resources Created

- DynamoDB table with unique naming
- Hash key for locking mechanism
- Point-in-time recovery enabled
- Proper tagging for resource management

## 🚀 Usage

```hcl
module "dynamodb_backend" {
  source = "./dynamodb"

  table_name                    = "my-terraform-locks"
  enable_point_in_time_recovery = true
  project_name                  = "my-project"
  environment                   = "global"

  tags = {
    Purpose = "Terraform State Locking"
  }
}
```
