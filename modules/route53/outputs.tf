# Route 53 Module - Outputs
# This file defines all outputs from the Route 53 module

output "hosted_zone_id" {
  description = "ID of the Route 53 hosted zone"
  value       = var.create_hosted_zone ? aws_route53_zone.main[0].zone_id : var.hosted_zone_id
}

output "hosted_zone_name" {
  description = "Name of the Route 53 hosted zone"
  value       = var.create_hosted_zone ? aws_route53_zone.main[0].name : var.domain_name
}

output "name_servers" {
  description = "Name servers for the hosted zone"
  value       = var.create_hosted_zone ? aws_route53_zone.main[0].name_servers : []
}

output "cloudfront_record_name" {
  description = "Name of the CloudFront A record"
  value       = var.create_cloudfront_record && length(aws_route53_record.cloudfront) > 0 ? values(aws_route53_record.cloudfront)[0].name : null
}

output "cloudfront_record_names" {
  description = "Names of all CloudFront A records"
  value       = [for record in aws_route53_record.cloudfront : record.name]
}

output "load_balancer_record_name" {
  description = "Name of the Load Balancer A record"
  value       = var.create_load_balancer_record ? aws_route53_record.load_balancer[0].name : null
}

output "cname_record_names" {
  description = "Names of CNAME records"
  value       = [for record in aws_route53_record.cname : record.name]
}

output "full_domain_name" {
  description = "Full domain name (subdomain.domain)"
  value       = var.subdomain != "" ? "${var.subdomain}.${var.domain_name}" : var.domain_name
}

output "route53_summary" {
  description = "Summary of Route 53 configuration"
  value = {
    domain_name                  = var.domain_name
    subdomain                    = var.subdomain
    full_domain_name             = var.subdomain != "" ? "${var.subdomain}.${var.domain_name}" : var.domain_name
    hosted_zone_created          = var.create_hosted_zone
    hosted_zone_id               = var.create_hosted_zone ? aws_route53_zone.main[0].zone_id : var.hosted_zone_id
    cloudfront_record_created    = var.create_cloudfront_record
    load_balancer_record_created = var.create_load_balancer_record
    cname_records_count          = length(aws_route53_record.cname)
  }
}
