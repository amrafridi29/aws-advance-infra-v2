# CloudFront Configuration
variable "enabled" {
  description = "Whether to enable the CloudFront distribution"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "custom_domain_names" {
  description = "List of custom domain names (aliases) for the CloudFront distribution"
  type        = list(string)
  default     = []
}

variable "ssl_certificate_arn" {
  description = "ARN of the SSL certificate for custom domains"
  type        = string
  default     = null
}

variable "origin_domain_name" {
  description = "Domain name of the origin (load balancer or S3 bucket)"
  type        = string
}

variable "origin_id" {
  description = "Unique identifier for the origin"
  type        = string
  default     = "default-origin"
}

variable "origin_type" {
  description = "Type of origin (s3, custom, alb)"
  type        = string
  default     = "custom"
  validation {
    condition     = contains(["s3", "custom", "alb"], var.origin_type)
    error_message = "Origin type must be one of: s3, custom, alb."
  }
}

# Cache Behavior Settings
variable "allowed_methods" {
  description = "HTTP methods allowed for the cache behavior"
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "cached_methods" {
  description = "HTTP methods that can be cached"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "forward_query_string" {
  description = "Whether to forward query strings to the origin"
  type        = bool
  default     = false
}

variable "forward_cookies" {
  description = "How to handle cookies (none, all, whitelist)"
  type        = string
  default     = "none"
}

# Cache TTL Settings
variable "min_ttl" {
  description = "Minimum time to live for cached objects (seconds)"
  type        = number
  default     = 0
}

variable "default_ttl" {
  description = "Default time to live for cached objects (seconds)"
  type        = number
  default     = 86400 # 24 hours
}

variable "max_ttl" {
  description = "Maximum time to live for cached objects (seconds)"
  type        = number
  default     = 31536000 # 1 year
}

# Performance Settings
variable "compress" {
  description = "Whether to compress objects for viewers"
  type        = bool
  default     = true
}

variable "enable_ipv6" {
  description = "Whether to enable IPv6 support"
  type        = bool
  default     = true
}

variable "price_class" {
  description = "Price class for the CloudFront distribution"
  type        = string
  default     = "PriceClass_100" # Use only North America and Europe
}

# Viewer Settings
variable "viewer_protocol_policy" {
  description = "Protocol policy for viewers (allow-all, redirect-to-https, https-only)"
  type        = string
  default     = "redirect-to-https"
}

variable "default_root_object" {
  description = "Default root object for the distribution"
  type        = string
  default     = "index.html"
}

# SSL/TLS Settings
variable "use_default_certificate" {
  description = "Whether to use the default CloudFront certificate"
  type        = bool
  default     = true
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for custom domain"
  type        = string
  default     = null
}

variable "ssl_support_method" {
  description = "SSL support method (sni-only, vip)"
  type        = string
  default     = "sni-only"
}

variable "minimum_protocol_version" {
  description = "Minimum SSL/TLS protocol version"
  type        = string
  default     = "TLSv1.2_2021"
}

# Security Headers
variable "enable_security_headers" {
  description = "Whether to enable security headers via CloudFront function"
  type        = bool
  default     = true
}

# Custom Origin Headers
variable "custom_origin_headers" {
  description = "Map of custom headers to send to the origin"
  type        = map(string)
  default     = {}
}

# Lambda Function Associations
variable "lambda_function_associations" {
  description = "List of Lambda function associations"
  type = list(object({
    event_type   = string
    lambda_arn   = string
    include_body = optional(bool, false)
  }))
  default = []
}

# Custom Cache Behaviors
variable "custom_cache_behaviors" {
  description = "List of custom cache behaviors"
  type = list(object({
    path_pattern           = string
    allowed_methods        = list(string)
    cached_methods         = list(string)
    target_origin_id       = string
    forward_query_string   = bool
    forward_cookies        = string
    min_ttl                = number
    default_ttl            = number
    max_ttl                = number
    compress               = bool
    viewer_protocol_policy = string
  }))
  default = []
}

# Custom Error Responses
variable "custom_error_responses" {
  description = "List of custom error responses"
  type = list(object({
    error_code            = number
    response_code         = string
    response_page_path    = string
    error_caching_min_ttl = number
  }))
  default = []
}

# Geo Restrictions
variable "geo_restrictions" {
  description = "Geo restrictions configuration"
  type = object({
    restriction_type = string
    locations        = list(string)
  })
  default = null
}

# Logging Configuration
variable "enable_logging" {
  description = "Whether to enable access logging"
  type        = bool
  default     = false
}

variable "log_bucket" {
  description = "S3 bucket for access logs"
  type        = string
  default     = null
}

variable "log_prefix" {
  description = "Prefix for access log files"
  type        = string
  default     = "cloudfront-logs"
}

variable "log_include_cookies" {
  description = "Whether to include cookies in access logs"
  type        = bool
  default     = false
}

# Cache Policy Settings
variable "create_cache_policy" {
  description = "Whether to create a custom cache policy"
  type        = bool
  default     = false
}

variable "cache_key_headers" {
  description = "List of headers to include in cache key"
  type        = list(string)
  default     = ["Accept", "Accept-Language", "Accept-Encoding"]
}

# Origin Request Policy Settings
variable "create_origin_request_policy" {
  description = "Whether to create a custom origin request policy"
  type        = bool
  default     = false
}

variable "origin_request_headers" {
  description = "List of headers to forward to origin"
  type        = list(string)
  default     = ["Host", "User-Agent", "Referer"]
}

# Tags
variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}
