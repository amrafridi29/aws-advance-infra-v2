# Basic ElastiCache Module Usage Example
# This example shows the minimal configuration needed for Redis caching

module "elasticache_basic" {
  source = "../../elasticache"

  # Required variables
  project_name = "myapp"
  environment  = "production"

  # Network configuration
  vpc_id = "vpc-12345678"
  subnet_ids = [
    "subnet-12345678",
    "subnet-87654321"
  ]

  # Security configuration
  allowed_security_group_ids = [
    "sg-12345678" # Application security group
  ]

  # Optional: Common tags
  tags = {
    Environment = "production"
    Project     = "myapp"
    Owner       = "devops"
  }
}

# Output the created resources
output "elasticache_basic_outputs" {
  description = "Basic ElastiCache module outputs"
  value = {
    cluster_id          = module.elasticache_basic.elasticache_cluster_id
    endpoint            = module.elasticache_basic.elasticache_endpoint
    port                = module.elasticache_basic.elasticache_port
    connection_string   = module.elasticache_basic.elasticache_connection_string
    security_group_id   = module.elasticache_basic.elasticache_security_group_id
    elasticache_summary = module.elasticache_basic.elasticache_summary
  }
}
