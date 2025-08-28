# DynamoDB Backend Module - Variables
# This file defines all variables used in the DynamoDB backend module

variable "table_name" {
  description = "Name of the DynamoDB table for Terraform state locking"
  type        = string
}

variable "enable_point_in_time_recovery" {
  description = "Enable point-in-time recovery for the DynamoDB table"
  type        = bool
  default     = true
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the DynamoDB table"
  type        = map(string)
  default     = {}
}
