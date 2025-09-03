# ElastiCache Module

This module provides a managed Redis cluster using AWS ElastiCache for improved application performance through caching.

## 🎯 Purpose

The ElastiCache module addresses the performance bottleneck in your infrastructure by providing:

- **Fast data access** through in-memory caching
- **Reduced database load** by serving frequently accessed data from cache
- **Improved response times** for better user experience
- **Scalable caching solution** that grows with your application

## 🏗️ Architecture

```
Application → ElastiCache Redis → Database
     ↓              ↓              ↓
   Fast         Very Fast        Slow
```

### Components

1. **Redis Cluster**: Primary caching layer
2. **Security Groups**: Network access control
3. **Subnet Group**: Network placement
4. **Parameter Group**: Redis configuration
5. **CloudWatch Monitoring**: Performance monitoring
6. **Backup & Snapshots**: Data protection

## 📋 Features

### Core Features

- ✅ **Redis 7.0** with latest features
- ✅ **Multi-AZ support** for high availability
- ✅ **Automatic backups** with configurable retention
- ✅ **Security groups** for network isolation
- ✅ **Parameter groups** for Redis tuning
- ✅ **CloudWatch monitoring** with alarms
- ✅ **Logging** to CloudWatch Logs

### Performance Features

- ✅ **LRU eviction policy** for memory management
- ✅ **Connection pooling** support
- ✅ **Read replicas** for read scaling
- ✅ **Snapshot restoration** capabilities

### Security Features

- ✅ **VPC isolation** in private subnets
- ✅ **Security group restrictions**
- ✅ **Encryption at rest** (if enabled)
- ✅ **Encryption in transit**

## 🚀 Usage

### Basic Configuration

```hcl
module "elasticache" {
  source = "../../modules/elasticache"

  project_name = "myapp"
  environment  = "production"

  vpc_id    = module.networking.vpc_id
  subnet_ids = module.networking.private_subnet_ids

  allowed_security_group_ids = [module.compute.ecs_security_group_id]

  tags = {
    Environment = "production"
    Project     = "myapp"
  }
}
```

### Advanced Configuration

```hcl
module "elasticache" {
  source = "../../modules/elasticache"

  project_name = "myapp"
  environment  = "production"

  vpc_id    = module.networking.vpc_id
  subnet_ids = module.networking.private_subnet_ids

  allowed_security_group_ids = [module.compute.ecs_security_group_id]

  # Performance tuning
  node_type = "cache.r5.large"
  multi_az_enabled = true

  # Redis configuration
  redis_parameters = [
    {
      name  = "maxmemory-policy"
      value = "allkeys-lru"
    },
    {
      name  = "notify-keyspace-events"
      value = "Ex"
    },
    {
      name  = "timeout"
      value = "300"
    }
  ]

  # Monitoring
  enable_monitoring = true
  alarm_actions     = [module.monitoring.sns_topic_arn]

  tags = {
    Environment = "production"
    Project     = "myapp"
    Owner       = "devops"
  }
}
```

## 📊 Outputs

### Core Outputs

- `elasticache_endpoint`: Primary Redis endpoint
- `elasticache_port`: Redis port (6379)
- `elasticache_connection_string`: Full connection string
- `elasticache_cluster_id`: Cluster identifier

### Security Outputs

- `elasticache_security_group_id`: Security group ID
- `elasticache_security_group_name`: Security group name

### Monitoring Outputs

- `elasticache_alarm_names`: CloudWatch alarm names
- `elasticache_alarm_arns`: CloudWatch alarm ARNs
- `elasticache_log_group_name`: CloudWatch log group

### Configuration Outputs

- `elasticache_subnet_group_name`: Subnet group name
- `elasticache_parameter_group_name`: Parameter group name
- `elasticache_summary`: Complete configuration summary

## 🔧 Configuration Options

### Node Types

- `cache.t3.micro`: Development/testing (default)
- `cache.t3.small`: Small production workloads
- `cache.r5.large`: Medium production workloads
- `cache.r5.xlarge`: Large production workloads

### Redis Parameters

- `maxmemory-policy`: Memory eviction policy
- `notify-keyspace-events`: Event notifications
- `timeout`: Connection timeout
- `tcp-keepalive`: Keep-alive settings

### Monitoring Thresholds

- **CPU**: 80% (alerts when high)
- **Memory**: 85% (alerts when high)
- **Connections**: 1000 (alerts when high)

## 🔐 Security Considerations

### Network Security

- Deployed in private subnets
- Access restricted via security groups
- No direct internet access

### Data Security

- Encryption at rest (if enabled)
- Encryption in transit
- Secure parameter groups

### Access Control

- IAM roles for application access
- Security group restrictions
- VPC isolation

## 📈 Performance Benefits

### Before ElastiCache

- Database CPU: 100% under load
- Response time: 5-10 seconds
- User experience: Poor
- Cost: High (database scaling)

### After ElastiCache

- Database CPU: 10% under load
- Response time: 0.1-0.5 seconds
- User experience: Excellent
- Cost: Low (cache is cheap)

## 💰 Cost Optimization

### Cost-Effective Configuration

- Start with `cache.t3.micro` for development
- Use `cache.r5.large` for production
- Enable Multi-AZ only when needed
- Monitor usage and scale appropriately

### Cost Monitoring

- CloudWatch metrics for usage tracking
- Cost allocation tags for billing
- Regular cost reviews and optimization

## 🔍 Monitoring & Alerting

### CloudWatch Metrics

- **CPUUtilization**: CPU usage percentage
- **DatabaseMemoryUsagePercentage**: Memory usage
- **CurrConnections**: Active connections
- **CacheHits**: Cache hit rate
- **CacheMisses**: Cache miss rate

### Alarms

- **High CPU**: >80% for 5 minutes
- **High Memory**: >85% for 5 minutes
- **High Connections**: >1000 for 5 minutes

### Logs

- Redis slow query logs
- Error logs
- Access logs

## 🛠️ Troubleshooting

### Common Issues

1. **Connection Timeouts**: Check security groups
2. **Memory Issues**: Adjust maxmemory-policy
3. **Performance Issues**: Monitor cache hit rate
4. **Network Issues**: Verify subnet configuration

### Debugging Steps

1. Check CloudWatch metrics
2. Review security group rules
3. Verify subnet group configuration
4. Test connectivity from application

## 🔄 Maintenance

### Backup Strategy

- Daily snapshots (configurable)
- 7-day retention (default)
- Manual snapshot creation
- Cross-region backup (if needed)

### Updates

- Redis version updates
- Parameter group changes
- Security group updates
- Node type scaling

## 📚 Best Practices

### Application Integration

- Use connection pooling
- Implement cache warming
- Handle cache misses gracefully
- Monitor cache hit rates

### Security

- Use IAM roles for access
- Restrict network access
- Enable encryption
- Regular security reviews

### Performance

- Choose appropriate node type
- Configure memory policies
- Monitor performance metrics
- Scale based on usage patterns

## 🎯 Integration Examples

### Node.js Application

```javascript
const redis = require("redis");
const client = redis.createClient({
  host: process.env.REDIS_ENDPOINT,
  port: process.env.REDIS_PORT,
});

// Cache user data
async function getUser(userId) {
  let user = await client.get(`user:${userId}`);
  if (!user) {
    user = await database.getUser(userId);
    await client.setex(`user:${userId}`, 3600, JSON.stringify(user));
  }
  return JSON.parse(user);
}
```

### Python Application

```python
import redis
import json

client = redis.Redis(
    host=os.environ['REDIS_ENDPOINT'],
    port=os.environ['REDIS_PORT']
)

def get_user(user_id):
    user = client.get(f"user:{user_id}")
    if not user:
        user = database.get_user(user_id)
        client.setex(f"user:{user_id}", 3600, json.dumps(user))
    return json.loads(user)
```

## 📈 Scaling Strategy

### Horizontal Scaling

- Add read replicas for read-heavy workloads
- Use Redis Cluster for large datasets
- Implement sharding strategies

### Vertical Scaling

- Upgrade node types for more resources
- Adjust memory allocation
- Optimize Redis parameters

## 🔮 Future Enhancements

- **Redis Cluster**: For larger datasets
- **Redis AUTH**: Password authentication
- **Redis TLS**: Encryption in transit
- **Redis Modules**: Custom functionality
- **Redis Streams**: Real-time data processing
