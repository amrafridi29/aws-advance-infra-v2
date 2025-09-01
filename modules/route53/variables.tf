# Route 53 Module - Variables
# This file defines all variables used in the Route 53 module

# Basic Configuration
variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

# Domain Configuration
variable "domain_name" {
  description = "Main domain name (e.g., softradev.online)"
  type        = string
}

variable "create_hosted_zone" {
  description = "Whether to create a new Route 53 hosted zone"
  type        = bool
  default     = true
}

variable "hosted_zone_id" {
  description = "Existing hosted zone ID (if not creating new one)"
  type        = string
  default     = ""
}

# CloudFront Configuration
variable "create_cloudfront_record" {
  description = "Whether to create A record for CloudFront distribution"
  type        = bool
  default     = true
}

variable "subdomain" {
  description = "Subdomain for CloudFront (e.g., staging, prod, www)"
  type        = string
  default     = ""
}

variable "cloudfront_domains" {
  description = "List of domains to create A records for CloudFront"
  type        = list(string)
  default     = []
}

variable "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  type        = string
  default     = ""
}

variable "cloudfront_hosted_zone_id" {
  description = "CloudFront hosted zone ID (always Z2FDTNDATAQYW2)"
  type        = string
  default     = "Z2FDTNDATAQYW2"
}

# Load Balancer Configuration
variable "create_load_balancer_record" {
  description = "Whether to create A record for load balancer"
  type        = bool
  default     = false
}

variable "lb_subdomain" {
  description = "Subdomain for load balancer (e.g., api, alb)"
  type        = string
  default     = ""
}

variable "load_balancer_dns_name" {
  description = "Load balancer DNS name"
  type        = string
  default     = ""
}

variable "load_balancer_zone_id" {
  description = "Load balancer hosted zone ID"
  type        = string
  default     = ""
}

# Additional CNAME Records
variable "cname_records" {
  description = "Map of CNAME records to create"
  type = map(object({
    value = string
    ttl   = optional(string, "300")
  }))
  default = {}
}

# Tags
variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}
