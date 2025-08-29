# Staging Environment - Variables
# This file defines all variables used in the staging environment configuration

# AWS Configuration
variable "aws_region" {
  description = "AWS region for the staging environment"
  type        = string
  default     = "us-east-2"
}

# Environment Configuration
variable "environment" {
  description = "Environment name (staging)"
  type        = string
  default     = "staging"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "aws-advance-infra"
}

variable "team_name" {
  description = "Name of the team responsible for this infrastructure"
  type        = string
  default     = "DevOps"
}

variable "cost_center" {
  description = "Cost center for billing purposes"
  type        = string
  default     = "IT-Infrastructure"
}

# Networking Configuration
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (leave empty for auto-generation)"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (leave empty for auto-generation)"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use single NAT Gateway for cost optimization"
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Whether to enable VPC Flow Logs"
  type        = bool
  default     = true
}

# Compute Configuration (for future use)
variable "instance_type" {
  description = "EC2 instance type for staging"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
  default     = 1
}

# Storage Configuration (for future use)
variable "db_instance_class" {
  description = "RDS instance class for staging"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS instance (GB)"
  type        = number
  default     = 20
}

variable "db_engine_version" {
  description = "RDS engine version"
  type        = string
  default     = "8.0.35"
}

# Security Configuration (for future use)
variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the infrastructure"
  type        = list(string)
  default     = ["10.0.0.0/16", "0.0.0.0/0"] # More permissive for staging
}

variable "enable_encryption" {
  description = "Enable encryption for resources"
  type        = bool
  default     = true
}

# Monitoring Configuration (for future use)
variable "enable_cloudwatch_logs" {
  description = "Enable CloudWatch logs"
  type        = bool
  default     = true
}

variable "enable_cloudtrail" {
  description = "Enable CloudTrail logging (disabled for staging - requires S3 bucket)"
  type        = bool
  default     = false
}

variable "retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
}

# Tags
variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
