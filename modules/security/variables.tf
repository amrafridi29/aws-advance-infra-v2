# Security Module - Variables
# This file defines all variables used in the security module

# Required Variables
variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC for security groups"
  type        = string
}

# IAM Configuration
variable "create_admin_role" {
  description = "Whether to create admin IAM role"
  type        = bool
  default     = false
}

variable "create_app_role" {
  description = "Whether to create application IAM role"
  type        = bool
  default     = true
}

variable "create_vpc_flow_log_role" {
  description = "Whether to create VPC Flow Log IAM role"
  type        = bool
  default     = true
}

variable "admin_role_name" {
  description = "Name for the admin IAM role"
  type        = string
  default     = ""
}

variable "app_role_name" {
  description = "Name for the application IAM role"
  type        = string
  default     = ""
}

# KMS Configuration
variable "enable_kms_encryption" {
  description = "Whether to create KMS encryption keys"
  type        = bool
  default     = true
}

variable "key_rotation_enabled" {
  description = "Whether to enable KMS key rotation"
  type        = bool
  default     = true
}

variable "kms_key_alias" {
  description = "Alias for the KMS encryption key"
  type        = string
  default     = ""
}

variable "kms_key_description" {
  description = "Description for the KMS encryption key"
  type        = string
  default     = ""
}

# Security Groups Configuration
variable "create_security_groups" {
  description = "Whether to create security groups"
  type        = bool
  default     = true
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed in security groups"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "enable_ssh_access" {
  description = "Whether to enable SSH access (port 22)"
  type        = bool
  default     = false
}

variable "enable_http_access" {
  description = "Whether to enable HTTP access (port 80)"
  type        = bool
  default     = true
}

variable "enable_https_access" {
  description = "Whether to enable HTTPS access (port 443)"
  type        = bool
  default     = true
}

variable "enable_rdp_access" {
  description = "Whether to enable RDP access (port 3389)"
  type        = bool
  default     = false
}

# Database Security
variable "enable_database_access" {
  description = "Whether to enable database access"
  type        = bool
  default     = true
}

variable "database_port" {
  description = "Database port for security group rules"
  type        = number
  default     = 3306
}

# Secrets Manager Configuration
variable "enable_secrets_manager" {
  description = "Whether to enable AWS Secrets Manager"
  type        = bool
  default     = false
}

variable "secrets" {
  description = "Map of secrets to create in Secrets Manager"
  type = map(object({
    description = string
    tags        = map(string)
  }))
  default = {}
}

# Tags
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
