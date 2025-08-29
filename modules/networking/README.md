# Networking Module

This module creates a comprehensive networking infrastructure including VPC, subnets, gateways, and routing.

## 🎯 Purpose

The networking module provides:

- **VPC**: Virtual Private Cloud with configurable CIDR
- **Subnets**: Public and private subnets across multiple availability zones
- **Internet Gateway**: For public internet access
- **NAT Gateway**: For private subnet internet access
- **Route Tables**: Proper routing between public and private subnets
- **Network ACLs**: Additional network security layer

## 🏗️ Architecture

```
                    Internet
                        |
                Internet Gateway
                        |
                Public Subnet (AZ1)
                        |
                Route Table (Public)
                        |
                Private Subnet (AZ1)
                        |
                NAT Gateway
                        |
                Route Table (Private)
```

## 📦 Resources Created

### Core Networking

- **VPC**: Main virtual private cloud
- **Subnets**: Public and private subnets across AZs
- **Internet Gateway**: For public internet access
- **NAT Gateway**: For private subnet internet access
- **Route Tables**: Separate routing for public and private subnets

### Security

- **Network ACLs**: Stateless network-level security
- **Default Security Groups**: Basic security group rules
- **VPC Flow Logs**: Network traffic logging

## 🚀 Usage

### Basic Usage

```hcl
module "networking" {
  source = "../../modules/networking"

  vpc_cidr           = "10.0.0.0/16"
  environment        = "staging"
  project_name       = "my-project"
  availability_zones = ["us-west-2a", "us-west-2b"]

  tags = {
    Environment = "staging"
    Project     = "my-project"
  }
}
```

### Advanced Usage

```hcl
module "networking" {
  source = "../../modules/networking"

  vpc_cidr             = "10.0.0.0/16"
  environment          = "production"
  project_name         = "my-project"
  availability_zones   = ["us-west-2a", "us-west-2b", "us-west-2c"]
  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_vpn_gateway   = true

  tags = {
    Environment = "production"
    Project     = "my-project"
    CostCenter  = "IT-Infrastructure"
  }
}
```

## 📋 Input Variables

### Required Variables

- `vpc_cidr`: CIDR block for the VPC
- `environment`: Environment name (e.g., staging, production)
- `project_name`: Name of the project
- `availability_zones`: List of availability zones to use

### Optional Variables

- `public_subnet_cidrs`: Custom CIDR blocks for public subnets
- `private_subnet_cidrs`: Custom CIDR blocks for private subnets
- `enable_nat_gateway`: Whether to create NAT Gateway (default: true)
- `single_nat_gateway`: Use single NAT Gateway for cost optimization (default: true)
- `enable_vpn_gateway`: Whether to create VPN Gateway (default: false)
- `enable_flow_logs`: Whether to enable VPC Flow Logs (default: true)

## 📤 Outputs

- `vpc_id`: ID of the created VPC
- `vpc_cidr_block`: CIDR block of the VPC
- `public_subnet_ids`: List of public subnet IDs
- `private_subnet_ids`: List of private subnet IDs
- `nat_gateway_ids`: List of NAT Gateway IDs
- `route_table_ids`: List of route table IDs

## 🔒 Security Features

- **Private Subnets**: Resources in private subnets cannot be accessed directly from the internet
- **NAT Gateway**: Private subnets can access internet through NAT Gateway
- **Network ACLs**: Additional network-level security rules
- **VPC Flow Logs**: Comprehensive network traffic logging
- **Security Groups**: Default security groups with restrictive rules

## 💰 Cost Optimization

- **Single NAT Gateway**: Option to use single NAT Gateway across AZs
- **Subnet Planning**: Efficient CIDR allocation
- **Resource Tagging**: Proper tagging for cost tracking
- **Lifecycle Management**: Automated cleanup of unused resources

## 🧪 Testing

### Test Scenarios

1. **Basic VPC Creation**: Verify VPC and subnets are created correctly
2. **Routing Validation**: Ensure proper routing between subnets
3. **Security Testing**: Verify security groups and ACLs work as expected
4. **High Availability**: Test failover scenarios across AZs

### Validation Rules

- VPC CIDR must be valid
- Subnet CIDRs must be within VPC CIDR
- Availability zones must be in the same region
- Subnet CIDRs must not overlap

## 📚 Dependencies

- AWS Provider
- No other modules required
- Appropriate AWS permissions for VPC, EC2, and IAM services

## 🔄 Updates and Maintenance

- **Adding AZs**: Can add new availability zones by updating variables
- **CIDR Changes**: VPC CIDR changes require careful planning
- **Security Updates**: Security groups and ACLs can be updated independently
- **Monitoring**: VPC Flow Logs provide visibility into network traffic
