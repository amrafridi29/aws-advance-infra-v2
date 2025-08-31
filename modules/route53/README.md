# Route 53 Module

This module manages Route 53 hosted zones and DNS records for your AWS infrastructure.

## Features

- **Hosted Zone Management**: Create new hosted zones or use existing ones
- **CloudFront Integration**: Automatic A records for CloudFront distributions
- **Load Balancer Integration**: A records for Application Load Balancers
- **Flexible CNAME Records**: Support for additional subdomains and services
- **Multi-Environment Support**: Staging and production configurations

## Usage

### Basic Usage

```hcl
module "route53" {
  source = "../../modules/route53"

  environment  = "staging"
  project_name = "aws-advance-infra"
  domain_name  = "softradev.online"
  subdomain    = "staging"

  # CloudFront configuration
  create_cloudfront_record = true
  cloudfront_domain_name  = "d2hpzrnlwvvw8x.cloudfront.net"

  tags = local.common_tags
}
```

### Advanced Usage

```hcl
module "route53" {
  source = "../../modules/route53"

  environment  = "production"
  project_name = "aws-advance-infra"
  domain_name  = "softradev.online"
  subdomain    = "prod"

  # CloudFront configuration
  create_cloudfront_record = true
  cloudfront_domain_name  = "your-production-cloudfront-domain.cloudfront.net"

  # Load balancer configuration
  create_load_balancer_record = true
  lb_subdomain               = "api"
  load_balancer_dns_name     = "your-alb-dns-name.elb.amazonaws.com"
  load_balancer_zone_id      = "Z35SXDOTRQ7X7K"

  # Additional CNAME records
  cname_records = {
    "www" = {
      value = "softradev.online"
      ttl   = "300"
    }
    "mail" = {
      value = "mail.softradev.online"
      ttl   = "3600"
    }
  }

  tags = local.common_tags
}
```

## Inputs

| Name                        | Description                                         | Type          | Default | Required |
| --------------------------- | --------------------------------------------------- | ------------- | ------- | :------: |
| environment                 | Environment name (e.g., staging, production)        | `string`      | n/a     |   yes    |
| project_name                | Name of the project                                 | `string`      | n/a     |   yes    |
| domain_name                 | Main domain name (e.g., softradev.online)           | `string`      | n/a     |   yes    |
| create_hosted_zone          | Whether to create a new Route 53 hosted zone        | `bool`        | `true`  |    no    |
| hosted_zone_id              | Existing hosted zone ID (if not creating new one)   | `string`      | `""`    |    no    |
| subdomain                   | Subdomain for CloudFront (e.g., staging, prod, www) | `string`      | `""`    |    no    |
| cloudfront_domain_name      | CloudFront distribution domain name                 | `string`      | `""`    |    no    |
| create_load_balancer_record | Whether to create A record for load balancer        | `bool`        | `false` |    no    |
| lb_subdomain                | Subdomain for load balancer (e.g., api, alb)        | `string`      | `""`    |    no    |
| load_balancer_dns_name      | Load balancer DNS name                              | `string`      | `""`    |    no    |
| load_balancer_zone_id       | Load balancer hosted zone ID                        | `string`      | `""`    |    no    |
| cname_records               | Map of CNAME records to create                      | `map(object)` | `{}`    |    no    |
| tags                        | Additional tags for resources                       | `map(string)` | `{}`    |    no    |

## Outputs

| Name                      | Description                                 |
| ------------------------- | ------------------------------------------- |
| hosted_zone_id            | ID of the created or referenced hosted zone |
| hosted_zone_name          | Name of the hosted zone                     |
| hosted_zone_name_servers  | Name servers for the hosted zone            |
| cloudfront_record_name    | Name of the CloudFront A record             |
| load_balancer_record_name | Name of the load balancer A record          |
| cname_record_names        | Names of all CNAME records                  |
| route53_summary           | Summary of Route 53 configuration           |
| full_domain_name          | Full domain name including subdomain        |
| name_servers              | Name servers for DNS configuration          |

## Examples

See the [examples](../examples/) directory for complete usage examples.

## Notes

- CloudFront hosted zone ID is always `Z2FDTNDATAQYW2`
- Load balancer hosted zone IDs vary by region
- CNAME records cannot be created for the root domain (use A records instead)
- Name servers are only available when creating new hosted zones
