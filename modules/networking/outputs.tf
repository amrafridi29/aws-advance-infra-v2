# Networking Module - Outputs
# This file defines all outputs from the networking module

# VPC Outputs
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.main.arn
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  value       = aws_subnet.private[*].cidr_block
}

# Gateway Outputs
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.main[*].id
}

output "nat_gateway_public_ips" {
  description = "List of NAT Gateway public IPs"
  value       = aws_eip.nat[*].public_ip
}

# Route Table Outputs
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}

output "route_table_ids" {
  description = "List of all route table IDs"
  value       = [aws_route_table.public.id, aws_route_table.private.id]
}

# Security Group Outputs
output "default_security_group_id" {
  description = "ID of the default security group"
  value       = aws_security_group.default.id
}

# VPC Flow Logs Outputs
output "flow_log_ids" {
  description = "List of VPC Flow Log IDs"
  value       = aws_flow_log.vpc_flow_log[*].id
}

output "flow_log_group_names" {
  description = "List of CloudWatch Log Group names for VPC Flow Logs"
  value       = aws_cloudwatch_log_group.vpc_flow_log[*].name
}

output "flow_log_iam_role_arn" {
  description = "ARN of the IAM role for VPC Flow Logs"
  value       = aws_iam_role.vpc_flow_log[*].arn
}

# Availability Zone Outputs
output "availability_zones" {
  description = "List of availability zones used"
  value       = var.availability_zones
}

# Network Information
output "network_summary" {
  description = "Summary of the networking infrastructure"
  value = {
    vpc_id              = aws_vpc.main.id
    vpc_cidr            = aws_vpc.main.cidr_block
    public_subnets      = length(aws_subnet.public)
    private_subnets     = length(aws_subnet.private)
    availability_zones  = length(var.availability_zones)
    nat_gateway_enabled = var.enable_nat_gateway
    flow_logs_enabled   = var.enable_flow_logs
  }
}
