# ECR Module - Variables
# This file defines all variables used in the ECR module

# Required Variables
variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

# ECR Repository Configuration
variable "enable_frontend_repository" {
  description = "Whether to create frontend ECR repository"
  type        = bool
  default     = true
}

variable "enable_backend_repository" {
  description = "Whether to create backend ECR repository"
  type        = bool
  default     = true
}

# ECR Features
variable "enable_image_scanning" {
  description = "Whether to enable image scanning on push"
  type        = bool
  default     = true
}

variable "enable_lifecycle_policies" {
  description = "Whether to enable lifecycle policies for automatic cleanup"
  type        = bool
  default     = true
}

variable "max_image_count" {
  description = "Maximum number of images to keep in each repository"
  type        = number
  default     = 10
}

# Tags
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
