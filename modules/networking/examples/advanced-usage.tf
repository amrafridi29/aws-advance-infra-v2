# Example: Advanced Networking Module Usage
# This file shows how to use the networking module with all available options

module "networking" {
  source = "../"

  # Required variables
  vpc_cidr           = "10.0.0.0/16"
  environment        = "production"
  project_name       = "my-project"
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

  # Custom subnet CIDRs (optional - will auto-generate if not provided)
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]

  # NAT Gateway configuration
  enable_nat_gateway = true
  single_nat_gateway = false # One NAT Gateway per AZ for high availability

  # VPN Gateway (optional)
  enable_vpn_gateway = true

  # VPC Flow Logs
  enable_flow_logs        = true
  flow_log_retention_days = 90

  # DNS configuration
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Public IP mapping
  map_public_ip_on_launch = true

  # Tags
  tags = {
    Environment = "production"
    Project     = "my-project"
    Owner       = "DevOps Team"
    CostCenter  = "IT-Infrastructure"
    Compliance  = "SOC2"
  }
}

# Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = module.networking.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.networking.private_subnet_ids
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = module.networking.nat_gateway_ids
}

output "nat_gateway_public_ips" {
  description = "NAT Gateway public IPs"
  value       = module.networking.nat_gateway_public_ips
}

output "route_table_ids" {
  description = "Route table IDs"
  value       = module.networking.route_table_ids
}

output "default_security_group_id" {
  description = "Default security group ID"
  value       = module.networking.default_security_group_id
}

output "flow_log_ids" {
  description = "VPC Flow Log IDs"
  value       = module.networking.flow_log_ids
}

output "network_summary" {
  description = "Complete network infrastructure summary"
  value       = module.networking.network_summary
}
