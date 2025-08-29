# Networking Module - Variables
# This file defines all variables used in the networking module

# Required Variables
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones to use for subnets"
  type        = list(string)
}

# Optional Variables with Defaults
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (auto-generated if not provided)"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (auto-generated if not provided)"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use single NAT Gateway for cost optimization (vs. one per AZ)"
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = "Whether to create VPN Gateway"
  type        = bool
  default     = false
}

variable "enable_flow_logs" {
  description = "Whether to enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "flow_log_retention_days" {
  description = "Number of days to retain VPC Flow Logs"
  type        = number
  default     = 30
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "Map public IP on launch for public subnets"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
