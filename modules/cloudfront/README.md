# 🌐 CloudFront Module

A comprehensive Terraform module for AWS CloudFront distributions with advanced features including security headers, caching policies, and origin access control.

## 🎯 Purpose

This module creates a CloudFront distribution that serves as a global CDN for your applications, providing:

- **Global Content Delivery**: Serve content from edge locations worldwide
- **Performance Optimization**: Automatic compression and caching
- **Security Enhancement**: Security headers and HTTPS enforcement
- **Cost Optimization**: Configurable price classes and caching strategies

## ✨ Features

### **Core Features**

- CloudFront distribution with configurable origins
- Origin Access Control for S3 buckets
- IPv6 support
- Multiple price classes (North America/Europe, All locations)

### **Security Features**

- Automatic HTTPS redirects
- Security headers via CloudFront functions
- Content Security Policy (CSP)
- HSTS (HTTP Strict Transport Security)
- XSS protection and frame options

### **Performance Features**

- Configurable cache TTL settings
- Automatic compression
- Custom cache behaviors
- Origin request policies

### **Advanced Features**

- Custom error responses
- Geo restrictions
- Access logging
- Lambda function associations

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    CloudFront Distribution                  │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   Edge Location │  │   Edge Location │  │   Edge      │ │
│  │   (North America)│  │   (Europe)      │  │   Location  │ │
│  │                 │  │                 │  │   (Asia)    │ │
│  │  - Cache        │  │  - Cache        │  │  - Cache    │ │
│  │  - Compression  │  │  - Compression  │  │  - Compression│ │
│  │  - Security     │  │  - Security     │  │  - Security │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Origin (Load Balancer)                  │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │              Application Load Balancer                  │ │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────┐ │ │
│  │  │  ECS Service    │  │  ECS Service    │  │  ECS    │ │ │
│  │  │  (Frontend)     │  │  (Backend)      │  │  Service│ │ │
│  │  └─────────────────┘  └─────────────────┘  └─────────┘ │ │
│  └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 📋 Resources Created

- `aws_cloudfront_distribution.main` - Main CloudFront distribution
- `aws_cloudfront_origin_access_control.main` - Origin access control
- `aws_cloudfront_function.security_headers` - Security headers function
- `aws_cloudfront_cache_policy.main` - Custom cache policy (optional)
- `aws_cloudfront_origin_request_policy.main` - Origin request policy (optional)

## 🔧 Usage

### **Basic Usage**

```hcl
module "cloudfront" {
  source = "../../modules/cloudfront"

  environment         = "staging"
  origin_domain_name = module.networking.load_balancer_dns_name
  origin_id          = "alb-origin"

  tags = var.tags
}
```

### **Advanced Usage**

```hcl
module "cloudfront" {
  source = "../../modules/cloudfront"

  environment         = "production"
  origin_domain_name = module.networking.load_balancer_dns_name
  origin_id          = "alb-origin"

  # Custom cache behaviors
  custom_cache_behaviors = [
    {
      path_pattern           = "/api/*"
      allowed_methods        = ["GET", "POST", "PUT", "DELETE"]
      cached_methods         = ["GET", "HEAD"]
      target_origin_id       = "alb-origin"
      forward_query_string   = true
      forward_cookies        = "all"
      min_ttl                = 0
      default_ttl            = 300
      max_ttl                = 3600
      compress               = true
      viewer_protocol_policy = "redirect-to-https"
    }
  ]

  # Custom error responses
  custom_error_responses = [
    {
      error_code            = 404
      response_code         = "200"
      response_page_path    = "/index.html"
      error_caching_min_ttl = 300
    }
  ]

  # Geo restrictions
  geo_restrictions = {
    restriction_type = "whitelist"
    locations        = ["US", "CA", "GB", "DE", "FR"]
  }

  # Logging
  enable_logging = true
  log_bucket     = module.storage.logs_bucket_name
  log_prefix     = "cloudfront-logs"

  tags = var.tags
}
```

## 📊 Performance Optimization

### **Cache TTL Settings**

```hcl
# Static assets (long cache)
min_ttl     = 86400      # 1 day
default_ttl = 604800     # 1 week
max_ttl     = 31536000   # 1 year

# Dynamic content (short cache)
min_ttl     = 0          # No cache
default_ttl = 300        # 5 minutes
max_ttl     = 3600       # 1 hour
```

### **Compression**

```hcl
compress = true  # Automatically compress text-based content
```

### **Price Classes**

```hcl
price_class = "PriceClass_100"  # North America and Europe only
price_class = "PriceClass_200"  # North America, Europe, Asia, Middle East, and Africa
price_class = "PriceClass_All"  # All locations
```

## 🔒 Security Features

### **Security Headers**

The module automatically adds security headers via CloudFront functions:

- **HSTS**: Forces HTTPS connections
- **CSP**: Content Security Policy
- **X-Frame-Options**: Prevents clickjacking
- **X-Content-Type-Options**: Prevents MIME type sniffing
- **X-XSS-Protection**: XSS protection
- **Referrer-Policy**: Controls referrer information

### **HTTPS Enforcement**

```hcl
viewer_protocol_policy = "redirect-to-https"  # Redirect HTTP to HTTPS
minimum_protocol_version = "TLSv1.2_2021"     # Modern TLS version
```

## 🌍 Global Distribution

### **Edge Locations**

CloudFront automatically serves content from the nearest edge location:

- **North America**: 20+ edge locations
- **Europe**: 15+ edge locations
- **Asia Pacific**: 20+ edge locations
- **South America**: 5+ edge locations
- **Africa**: 5+ edge locations

### **Performance Benefits**

- **Reduced Latency**: Content served from edge locations
- **Higher Throughput**: Optimized network paths
- **Cost Savings**: Reduced origin server load
- **Global Reach**: Consistent performance worldwide

## 📈 Monitoring & Logging

### **Access Logs**

```hcl
enable_logging = true
log_bucket     = "your-s3-bucket"
log_prefix     = "cloudfront-logs"
log_include_cookies = false
```

### **CloudWatch Metrics**

CloudFront automatically provides metrics for:

- Request count and error rates
- Cache hit/miss ratios
- Data transfer
- Latency statistics

## 💰 Cost Optimization

### **Price Classes**

- **PriceClass_100**: $0.085 per GB (North America/Europe)
- **PriceClass_200**: $0.080 per GB (Adds Asia/Middle East/Africa)
- **PriceClass_All**: $0.075 per GB (All locations)

### **Caching Strategy**

- **Static Assets**: Long TTL (1 week to 1 year)
- **Dynamic Content**: Short TTL (5 minutes to 1 hour)
- **API Responses**: No cache or very short TTL

## 🔧 Configuration Examples

### **S3 Origin**

```hcl
module "cloudfront" {
  source = "../../modules/cloudfront"

  environment         = "staging"
  origin_domain_name = "your-bucket.s3.amazonaws.com"
  origin_id          = "s3-origin"

  # S3-specific settings
  custom_origin_headers = {
    "X-Origin-Type" = "S3"
  }

  tags = var.tags
}
```

### **Custom Domain with ACM**

```hcl
module "cloudfront" {
  source = "../../modules/cloudfront"

  environment         = "production"
  origin_domain_name = module.networking.load_balancer_dns_name
  origin_id          = "alb-origin"

  # Custom domain
  use_default_certificate = false
  acm_certificate_arn     = "arn:aws:acm:us-east-1:123456789012:certificate/your-cert"

  tags = var.tags
}
```

## 🚨 Troubleshooting

### **Common Issues**

#### **1. Origin Access Denied**

- Ensure origin access control is properly configured
- Check S3 bucket policy for CloudFront access
- Verify origin domain name is correct

#### **2. Cache Not Working**

- Check TTL settings
- Verify cache behaviors are configured correctly
- Ensure origin is responding with proper headers

#### **3. HTTPS Redirect Issues**

- Verify SSL certificate configuration
- Check viewer protocol policy settings
- Ensure origin supports HTTPS

### **Debug Commands**

```bash
# Check distribution status
aws cloudfront get-distribution --id <distribution-id>

# Test edge location performance
curl -I https://<distribution-domain>/test-file

# View access logs
aws s3 ls s3://<log-bucket>/<log-prefix>/
```

## 📚 Additional Resources

- [AWS CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [CloudFront Best Practices](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/best-practices.html)
- [CloudFront Functions](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/functions.html)
- [CloudFront Pricing](https://aws.amazon.com/cloudfront/pricing/)

---

## 🎯 Next Steps

After deploying CloudFront:

1. **Update DNS**: Point your domain to CloudFront
2. **Test Performance**: Verify global access and caching
3. **Monitor Metrics**: Set up CloudWatch alarms
4. **Optimize Caching**: Adjust TTL settings based on usage
5. **Security Review**: Validate security headers and HTTPS

**Happy CDN-ing! 🌐**
