# CloudFront Distribution
resource "aws_cloudfront_distribution" "main" {
  enabled             = var.enabled
  is_ipv6_enabled     = var.enable_ipv6
  comment             = "CloudFront distribution for ${var.environment} environment"
  default_root_object = var.default_root_object
  price_class         = var.price_class

  # Custom domain aliases
  aliases = var.custom_domain_names

  # Origin configuration
  origin {
    domain_name = var.origin_domain_name
    origin_id   = var.origin_id

    # For load balancer origins, we don't need origin access control
    # Origin access control is only for S3 bucket origins
    origin_access_control_id = var.origin_type == "s3" ? aws_cloudfront_origin_access_control.main[0].id : null

    # Custom origin configuration for load balancers and custom origins
    dynamic "custom_origin_config" {
      for_each = var.origin_type != "s3" ? [1] : []
      content {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }

    # Custom origin headers
    dynamic "custom_header" {
      for_each = var.custom_origin_headers
      content {
        name  = custom_header.key
        value = custom_header.value
      }
    }
  }

  # Default cache behavior
  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = var.origin_id

    forwarded_values {
      query_string = var.forward_query_string
      cookies {
        forward = var.forward_cookies
      }
    }

    # Cache settings
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
    compress               = var.compress
    viewer_protocol_policy = var.viewer_protocol_policy

    # Security headers
    dynamic "lambda_function_association" {
      for_each = var.lambda_function_associations
      content {
        event_type   = lambda_function_association.value.event_type
        lambda_arn   = lambda_function_association.value.lambda_arn
        include_body = lookup(lambda_function_association.value, "include_body", false)
      }
    }

    # CloudFront function association for security headers
    dynamic "function_association" {
      for_each = var.enable_security_headers ? [1] : []
      content {
        event_type   = "viewer-response"
        function_arn = aws_cloudfront_function.security_headers[0].arn
      }
    }
  }

  # Custom cache behaviors
  dynamic "ordered_cache_behavior" {
    for_each = var.custom_cache_behaviors
    content {
      path_pattern     = ordered_cache_behavior.value.path_pattern
      allowed_methods  = ordered_cache_behavior.value.allowed_methods
      cached_methods   = ordered_cache_behavior.value.cached_methods
      target_origin_id = ordered_cache_behavior.value.target_origin_id

      forwarded_values {
        query_string = ordered_cache_behavior.value.forward_query_string
        cookies {
          forward = ordered_cache_behavior.value.forward_cookies
        }
      }

      min_ttl                = ordered_cache_behavior.value.min_ttl
      default_ttl            = ordered_cache_behavior.value.default_ttl
      max_ttl                = ordered_cache_behavior.value.max_ttl
      compress               = ordered_cache_behavior.value.compress
      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
    }
  }

  # Viewer certificate configuration
  viewer_certificate {
    cloudfront_default_certificate = length(var.custom_domain_names) == 0
    acm_certificate_arn            = length(var.custom_domain_names) > 0 ? var.ssl_certificate_arn : null
    ssl_support_method             = length(var.custom_domain_names) > 0 ? "sni-only" : null
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  # Custom error responses
  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
    }
  }

  # Geo restrictions
  restrictions {
    geo_restriction {
      restriction_type = var.geo_restrictions != null ? var.geo_restrictions.restriction_type : "none"
      locations        = var.geo_restrictions != null ? var.geo_restrictions.locations : []
    }
  }

  # Logging configuration
  dynamic "logging_config" {
    for_each = var.enable_logging ? [1] : []
    content {
      include_cookies = var.log_include_cookies
      bucket          = var.log_bucket
      prefix          = var.log_prefix
    }
  }

  # Tags
  tags = merge(var.tags, {
    Name        = "aws-advance-infra-${var.environment}-cloudfront"
    Environment = var.environment
    Module      = "cloudfront"
  })

  # Explicit dependencies
  depends_on = [aws_cloudfront_function.security_headers]
}

# Origin Access Control (only for S3 origins)
resource "aws_cloudfront_origin_access_control" "main" {
  count                             = var.origin_type == "s3" ? 1 : 0
  name                              = "aws-advance-infra-${var.environment}-oac"
  description                       = "Origin Access Control for ${var.environment} environment"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Function for Security Headers
resource "aws_cloudfront_function" "security_headers" {
  count   = var.enable_security_headers ? 1 : 0
  name    = "aws-advance-infra-${var.environment}-security-headers"
  runtime = "cloudfront-js-1.0"
  comment = "Security headers function for ${var.environment} environment"
  publish = true
  code    = file("${path.module}/functions/security-headers.js")
}

# Note: CloudFront functions are associated directly in the distribution configuration
# The function association is handled in the default_cache_behavior block

# CloudFront Cache Policy
resource "aws_cloudfront_cache_policy" "main" {
  count       = var.create_cache_policy ? 1 : 0
  name        = "aws-advance-infra-${var.environment}-cache-policy"
  comment     = "Cache policy for ${var.environment} environment"
  default_ttl = var.default_ttl
  max_ttl     = var.max_ttl
  min_ttl     = var.min_ttl

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = var.cache_key_headers
      }
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

# CloudFront Origin Request Policy
resource "aws_cloudfront_origin_request_policy" "main" {
  count   = var.create_origin_request_policy ? 1 : 0
  name    = "aws-advance-infra-${var.environment}-origin-request-policy"
  comment = "Origin request policy for ${var.environment} environment"

  cookies_config {
    cookie_behavior = "none"
  }

  headers_config {
    header_behavior = "whitelist"
    headers {
      items = var.origin_request_headers
    }
  }

  query_strings_config {
    query_string_behavior = "none"
  }
}
