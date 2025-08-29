# Storage Module - Variables
# This file defines all variables used in the storage module

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

variable "subnet_ids" {
  description = "List of subnet IDs for RDS and ElastiCache"
  type        = list(string)
}

# S3 Storage Configuration
variable "enable_s3_storage" {
  description = "Whether to create S3 storage infrastructure"
  type        = bool
  default     = true
}

variable "s3_lifecycle_enabled" {
  description = "Whether to enable S3 lifecycle policies"
  type        = bool
  default     = false
}

variable "s3_versioning_enabled" {
  description = "Whether to enable S3 versioning"
  type        = bool
  default     = false
}

variable "s3_encryption_enabled" {
  description = "Whether to enable S3 encryption"
  type        = bool
  default     = true
}

variable "s3_application_bucket_name" {
  description = "Name for the application S3 bucket"
  type        = string
  default     = ""
}

variable "s3_backup_bucket_name" {
  description = "Name for the backup S3 bucket"
  type        = string
  default     = ""
}

variable "s3_logs_bucket_name" {
  description = "Name for the logs S3 bucket"
  type        = string
  default     = ""
}

variable "s3_static_assets_bucket_name" {
  description = "Name for the static assets S3 bucket"
  type        = string
  default     = ""
}

# RDS Configuration
variable "enable_rds" {
  description = "Whether to create RDS database infrastructure"
  type        = bool
  default     = false
}

variable "rds_engine" {
  description = "RDS database engine"
  type        = string
  default     = "mysql"
}

variable "rds_engine_version" {
  description = "RDS database engine version"
  type        = string
  default     = "8.0.35"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
  validation {
    condition     = can(regex("^(db\\.t3\\.|db\\.m5\\.|db\\.r5\\.|db\\.m6g\\.|db\\.r6g\\.)", var.rds_instance_class))
    error_message = "RDS instance class must support encryption at rest (t3, m5, r5, m6g, r6g or newer)."
  }
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20
}

variable "rds_multi_az" {
  description = "Whether to enable RDS Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "rds_backup_retention" {
  description = "RDS backup retention period in days"
  type        = number
  default     = 7
}

variable "rds_database_name" {
  description = "RDS database name"
  type        = string
  default     = ""
}

variable "rds_username" {
  description = "RDS master username"
  type        = string
  default     = "admin"
}

variable "rds_password" {
  description = "RDS master password (should be provided via tfvars)"
  type        = string
  sensitive   = true
  default     = ""
}

# ElastiCache Configuration
variable "enable_elasticache" {
  description = "Whether to create ElastiCache infrastructure"
  type        = bool
  default     = false
}

variable "elasticache_engine" {
  description = "ElastiCache engine (redis or memcached)"
  type        = string
  default     = "redis"
  validation {
    condition     = contains(["redis", "memcached"], var.elasticache_engine)
    error_message = "ElastiCache engine must be either 'redis' or 'memcached'."
  }
}

variable "elasticache_node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "elasticache_cluster_size" {
  description = "ElastiCache cluster size"
  type        = number
  default     = 1
}

variable "elasticache_port" {
  description = "ElastiCache port"
  type        = number
  default     = 6379
}

# EBS Configuration
variable "enable_ebs" {
  description = "Whether to create EBS volume infrastructure"
  type        = bool
  default     = false
}

variable "ebs_volume_size" {
  description = "EBS volume size in GB"
  type        = number
  default     = 20
}

variable "ebs_volume_type" {
  description = "EBS volume type"
  type        = string
  default     = "gp3"
  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2", "st1", "sc1"], var.ebs_volume_type)
    error_message = "EBS volume type must be one of: gp2, gp3, io1, io2, st1, sc1."
  }
}

# Encryption Configuration
variable "kms_key_arn" {
  description = "ARN of the KMS key for encryption"
  type        = string
  default     = ""
}

# Security Configuration
variable "database_security_group_id" {
  description = "ID of the database security group"
  type        = string
  default     = ""
}

variable "cache_security_group_id" {
  description = "ID of the cache security group"
  type        = string
  default     = ""
}

# Tags
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
