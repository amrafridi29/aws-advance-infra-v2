# Route 53 Module - Main Configuration
# This file creates Route 53 hosted zones and DNS records

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Local values for consistent naming and configuration
locals {
  # Common tags for all resources
  common_tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      Purpose     = "DNS Management"
      ManagedBy   = "Terraform"
      Component   = "Route53"
    }
  )

  # Naming convention
  name_prefix = "${var.project_name}-${var.environment}"
}

# Route 53 Hosted Zone
resource "aws_route53_zone" "main" {
  count = var.create_hosted_zone ? 1 : 0

  name = var.domain_name

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-hosted-zone"
      Type = "Hosted Zone"
    }
  )
}

# A Record for CloudFront Distribution
resource "aws_route53_record" "cloudfront" {
  count = var.create_cloudfront_record ? 1 : 0

  zone_id = var.hosted_zone_id != "" ? var.hosted_zone_id : aws_route53_zone.main[0].zone_id
  name    = var.subdomain != "" ? "${var.subdomain}.${var.domain_name}" : var.domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

# A Record for Load Balancer (if needed)
resource "aws_route53_record" "load_balancer" {
  count = var.create_load_balancer_record ? 1 : 0

  zone_id = var.hosted_zone_id != "" ? var.hosted_zone_id : aws_route53_zone.main[0].zone_id
  name    = var.lb_subdomain != "" ? "${var.lb_subdomain}.${var.domain_name}" : var.domain_name
  type    = "A"

  alias {
    name                   = var.load_balancer_dns_name
    zone_id                = var.load_balancer_zone_id
    evaluate_target_health = true
  }
}

# CNAME Records for additional subdomains
resource "aws_route53_record" "cname" {
  for_each = var.cname_records

  zone_id = var.hosted_zone_id != "" ? var.hosted_zone_id : aws_route53_zone.main[0].zone_id
  name    = each.key != "@" ? "${each.key}.${var.domain_name}" : var.domain_name
  type    = "CNAME"
  ttl     = lookup(each.value, "ttl", "300")
  records = [each.value.value]
}
