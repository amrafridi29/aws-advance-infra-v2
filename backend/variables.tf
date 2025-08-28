# Backend Infrastructure - Variables
# This file defines all variables used in the backend infrastructure

# AWS Configuration
variable "aws_region" {
  description = "AWS region for the backend infrastructure"
  type        = string
  default     = "us-west-2"
}

# Project Configuration
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "aws-advance-infra"
}

variable "environment" {
  description = "Environment name (global for backend)"
  type        = string
  default     = "global"
}

# S3 Configuration
variable "s3_bucket_name" {
  description = "Name of the S3 bucket for Terraform state (leave empty for auto-generation)"
  type        = string
  default     = ""
}

variable "enable_s3_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_s3_encryption" {
  description = "Enable encryption for the S3 bucket"
  type        = bool
  default     = true
}

# DynamoDB Configuration
variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking (leave empty for auto-generation)"
  type        = string
  default     = ""
}

variable "enable_dynamodb_point_in_time_recovery" {
  description = "Enable point-in-time recovery for DynamoDB table"
  type        = bool
  default     = true
}

# Tags
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
