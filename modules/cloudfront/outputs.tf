# CloudFront Distribution Outputs
output "distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.main.id
}

output "distribution_arn" {
  description = "ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.main.arn
}

output "distribution_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.main.domain_name
}

output "distribution_hosted_zone_id" {
  description = "Hosted zone ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.main.hosted_zone_id
}

output "distribution_status" {
  description = "Current status of the CloudFront distribution"
  value       = aws_cloudfront_distribution.main.status
}

# Origin Access Control Outputs
output "origin_access_control_id" {
  description = "ID of the origin access control"
  value       = var.origin_type == "s3" ? aws_cloudfront_origin_access_control.main[0].id : null
}

output "origin_access_control_name" {
  description = "Name of the origin access control"
  value       = var.origin_type == "s3" ? aws_cloudfront_origin_access_control.main[0].name : null
}

# CloudFront Function Outputs
output "security_headers_function_arn" {
  description = "ARN of the security headers function"
  value       = var.enable_security_headers ? aws_cloudfront_function.security_headers[0].arn : null
}

output "security_headers_function_name" {
  description = "Name of the security headers function"
  value       = var.enable_security_headers ? aws_cloudfront_function.security_headers[0].name : null
}

# Cache Policy Outputs
output "cache_policy_id" {
  description = "ID of the custom cache policy"
  value       = var.create_cache_policy ? aws_cloudfront_cache_policy.main[0].id : null
}

output "cache_policy_arn" {
  description = "ARN of the custom cache policy"
  value       = var.create_cache_policy ? aws_cloudfront_cache_policy.main[0].arn : null
}

# Origin Request Policy Outputs
output "origin_request_policy_id" {
  description = "ID of the custom origin request policy"
  value       = var.create_origin_request_policy ? aws_cloudfront_origin_request_policy.main[0].id : null
}

output "origin_request_policy_arn" {
  description = "ARN of the custom origin request policy"
  value       = var.create_origin_request_policy ? aws_cloudfront_origin_request_policy.main[0].arn : null
}

# Comprehensive Summary
output "cloudfront_summary" {
  description = "Summary of CloudFront configuration"
  value = {
    distribution_id               = aws_cloudfront_distribution.main.id
    distribution_domain_name      = aws_cloudfront_distribution.main.domain_name
    distribution_status           = aws_cloudfront_distribution.main.status
    enabled                       = var.enabled
    ipv6_enabled                  = var.enable_ipv6
    price_class                   = var.price_class
    security_headers              = var.enable_security_headers
    logging_enabled               = var.enable_logging
    custom_cache_behaviors        = length(var.custom_cache_behaviors)
    custom_error_responses        = length(var.custom_error_responses)
    geo_restrictions              = var.geo_restrictions != null
    ssl_protocol_version          = var.minimum_protocol_version
    viewer_protocol_policy        = var.viewer_protocol_policy
    compression_enabled           = var.compress
    cache_policy_created          = var.create_cache_policy
    origin_request_policy_created = var.create_origin_request_policy
  }
}
