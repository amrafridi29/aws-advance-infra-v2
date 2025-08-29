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

# IAM and KMS resources are now handled by dedicated modules

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
