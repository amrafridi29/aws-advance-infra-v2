# Encryption Module - Variables
# This file defines all variables used in the encryption module

# Required Variables
variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

# KMS Encryption Configuration
variable "enable_kms_encryption" {
  description = "Whether to create KMS encryption keys"
  type        = bool
  default     = true
}

variable "enable_application_key" {
  description = "Whether to create application-specific encryption key"
  type        = bool
  default     = false
}

variable "enable_database_key" {
  description = "Whether to create database encryption key"
  type        = bool
  default     = false
}

variable "enable_backup_key" {
  description = "Whether to create backup encryption key"
  type        = bool
  default     = false
}

# Key Configuration
variable "key_rotation_enabled" {
  description = "Whether to enable KMS key rotation"
  type        = bool
  default     = true
}

variable "deletion_window_in_days" {
  description = "Number of days to wait before deleting KMS keys"
  type        = number
  default     = 7
}

variable "key_description" {
  description = "Description for the main KMS encryption key"
  type        = string
  default     = ""
}

variable "application_key_description" {
  description = "Description for the application encryption key"
  type        = string
  default     = ""
}

variable "database_key_description" {
  description = "Description for the database encryption key"
  type        = string
  default     = ""
}

variable "backup_key_description" {
  description = "Description for the backup encryption key"
  type        = string
  default     = ""
}

# Key Aliases
variable "main_key_alias" {
  description = "Alias for the main KMS encryption key"
  type        = string
  default     = ""
}

variable "application_key_alias" {
  description = "Alias for the application encryption key"
  type        = string
  default     = ""
}

variable "database_key_alias" {
  description = "Alias for the database encryption key"
  type        = string
  default     = ""
}

variable "backup_key_alias" {
  description = "Alias for the backup encryption key"
  type        = string
  default     = ""
}

# Multi-Region Configuration
variable "enable_multi_region" {
  description = "Whether to enable multi-region keys"
  type        = bool
  default     = false
}

variable "replica_regions" {
  description = "List of regions for key replication"
  type        = list(string)
  default     = []
}

# Tags
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
