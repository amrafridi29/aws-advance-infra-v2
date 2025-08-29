# IAM Module - Variables
# This file defines all variables used in the IAM module

# Required Variables
variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

# IAM Roles Configuration
variable "create_app_role" {
  description = "Whether to create application IAM role"
  type        = bool
  default     = true
}

variable "create_admin_role" {
  description = "Whether to create admin IAM role"
  type        = bool
  default     = false
}

variable "create_service_role" {
  description = "Whether to create service IAM role"
  type        = bool
  default     = false
}

variable "create_vpc_flow_log_role" {
  description = "Whether to create VPC Flow Log IAM role"
  type        = bool
  default     = true
}

variable "app_role_name" {
  description = "Name for the application IAM role"
  type        = string
  default     = ""
}

variable "admin_role_name" {
  description = "Name for the admin IAM role"
  type        = string
  default     = ""
}

variable "service_role_name" {
  description = "Name for the service IAM role"
  type        = string
  default     = ""
}

# IAM Policies Configuration
variable "custom_policies" {
  description = "Map of custom IAM policies to create"
  type = map(object({
    description = string
    policy      = string
  }))
  default = {}
}

variable "enable_cross_account_access" {
  description = "Whether to enable cross-account access"
  type        = bool
  default     = false
}

variable "trusted_account_ids" {
  description = "List of trusted AWS account IDs for cross-account access"
  type        = list(string)
  default     = []
}

# Application Role Permissions
variable "app_role_s3_buckets" {
  description = "List of S3 bucket names the app role can access"
  type        = list(string)
  default     = []
}

variable "app_role_kms_keys" {
  description = "List of KMS key ARNs the app role can access"
  type        = list(string)
  default     = []
}

# Tags
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
