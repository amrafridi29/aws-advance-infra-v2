# S3 Backend Module

This module creates a secure S3 bucket for storing Terraform state files.

## 🎯 Purpose

- **State Storage**: Secure storage for Terraform state files
- **Versioning**: Track changes to state files over time
- **Encryption**: Data encrypted at rest and in transit
- **Access Control**: Block public access and enforce security policies

## 🏗️ Resources Created

- S3 bucket with unique naming
- Versioning enabled
- Server-side encryption
- Public access blocking
- Lifecycle policies for cost optimization
- Access logging configuration

## 🚀 Usage

```hcl
module "s3_backend" {
  source = "./s3"

  bucket_name       = "my-terraform-state"
  enable_versioning = true
  enable_encryption = true
  project_name      = "my-project"
  environment       = "global"

  tags = {
    Purpose = "Terraform State Storage"
  }
}
```
