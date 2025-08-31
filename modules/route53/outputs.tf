# Route 53 Module - Outputs
# This file defines all outputs from the Route 53 module

# Hosted Zone Outputs
output "hosted_zone_id" {
  description = "ID of the created or referenced hosted zone"
  value       = var.hosted_zone_id != "" ? var.hosted_zone_id : aws_route53_zone.main[0].zone_id
}

output "hosted_zone_name" {
  description = "Name of the hosted zone"
  value       = var.domain_name
}

output "hosted_zone_name_servers" {
  description = "Name servers for the hosted zone"
  value       = var.create_hosted_zone ? aws_route53_zone.main[0].name_servers : []
}

# DNS Record Outputs
output "cloudfront_record_name" {
  description = "Name of the CloudFront A record"
  value       = var.create_cloudfront_record ? aws_route53_record.cloudfront[0].name : null
}

output "load_balancer_record_name" {
  description = "Name of the load balancer A record"
  value       = var.create_load_balancer_record ? aws_route53_record.load_balancer[0].name : null
}

output "cname_record_names" {
  description = "Names of all CNAME records"
  value       = [for record in aws_route53_record.cname : record.name]
}

# Route 53 Summary
output "route53_summary" {
  description = "Summary of Route 53 configuration"
  value = {
    domain_name                  = var.domain_name
    hosted_zone_created          = var.create_hosted_zone
    hosted_zone_id               = var.hosted_zone_id != "" ? var.hosted_zone_id : (var.create_hosted_zone ? aws_route53_zone.main[0].zone_id : null)
    cloudfront_record_created    = var.create_cloudfront_record
    load_balancer_record_created = var.create_load_balancer_record
    cname_records_count          = length(var.cname_records)
    subdomain                    = var.subdomain
    full_domain_name             = var.subdomain != "" ? "${var.subdomain}.${var.domain_name}" : var.domain_name
  }
}

# Full Domain Information
output "full_domain_name" {
  description = "Full domain name including subdomain"
  value       = var.subdomain != "" ? "${var.subdomain}.${var.domain_name}" : var.domain_name
}

output "name_servers" {
  description = "Name servers for DNS configuration"
  value       = var.create_hosted_zone ? aws_route53_zone.main[0].name_servers : []
}
