# 🌐 Domain Setup Guide for softradev.online

This guide will help you configure your domain `softradev.online` with AWS Route 53 and CloudFront.

## 📋 Prerequisites

- Domain purchased from Hostinger: `softradev.online`
- AWS account with appropriate permissions
- Terraform infrastructure already deployed

## 🚀 Step-by-Step Setup

### **Step 1: Deploy Route 53 Module**

First, deploy the Route 53 module to create the hosted zone:

```bash
cd environments/staging
terraform plan -target=module.route53
terraform apply -target=module.route53
```

### **Step 2: Get Name Servers**

After deployment, get the name servers from the output:

```bash
terraform output name_servers
```

You should see something like:

```
[
  "ns-1234.awsdns-12.com",
  "ns-5678.awsdns-34.net",
  "ns-9012.awsdns-56.org",
  "ns-3456.awsdns-78.co.uk"
]
```

### **Step 3: Update Hostinger DNS**

1. **Login to Hostinger Control Panel**
2. **Go to Domains → softradev.online → DNS Zone**
3. **Change Name Servers** to AWS Route 53 name servers:
   - Replace existing name servers with the 4 AWS name servers from Step 2
4. **Save Changes**

**Note**: DNS propagation can take 24-48 hours, but usually happens within a few hours.

### **Step 4: Verify DNS Propagation**

Check if your domain is using AWS name servers:

```bash
# Check name servers
dig NS softradev.online

# Check if AWS name servers are active
dig @ns-1234.awsdns-12.com softradev.online
```

### **Step 5: Test Your Custom Domain**

Once DNS propagation is complete, test your custom domain:

```bash
# Test staging subdomain
curl -I http://staging.softradev.online

# Test CloudFront domain
curl -I http://d2hpzrnlwvvw8x.cloudfront.net
```

## 🔧 Configuration Options

### **Staging Environment**

- **Subdomain**: `staging.softradev.online`
- **Target**: CloudFront distribution
- **SSL**: CloudFront default certificate

### **Production Environment** (when ready)

- **Subdomain**: `prod.softradev.online` or `www.softradev.online`
- **Target**: Production CloudFront distribution
- **SSL**: Custom ACM certificate

### **API Subdomain** (optional)

- **Subdomain**: `api.softradev.online`
- **Target**: Load balancer directly
- **Use Case**: Direct API access bypassing CloudFront

## 📊 DNS Record Structure

```
softradev.online          → Route 53 Hosted Zone
├── staging.softradev.online → CloudFront Distribution (A Record)
├── prod.softradev.online    → Production CloudFront (A Record)
├── api.softradev.online     → Load Balancer (A Record)
└── www.softradev.online     → Main Site (CNAME to root)
```

## 🚨 Important Notes

1. **Name Server Change**: This is a critical change that affects your entire domain
2. **Propagation Time**: Allow 24-48 hours for full DNS propagation
3. **Email Services**: If you have email services, ensure they're configured before changing name servers
4. **Backup**: Keep a record of your original Hostinger name servers

## 🔍 Troubleshooting

### **DNS Not Propagating**

- Wait longer (up to 48 hours)
- Check if name servers are correctly set in Hostinger
- Verify Route 53 hosted zone is active

### **Domain Not Accessible**

- Check if CloudFront distribution is deployed
- Verify Route 53 records are created
- Check security group rules

### **SSL Certificate Issues**

- CloudFront uses default certificates for custom domains
- For production, consider using ACM certificates

## 📚 Next Steps

After successful domain setup:

1. **Test End-to-End**: Verify complete flow from custom domain → CloudFront → ALB → ECS
2. **Production Environment**: Deploy production with `prod.softradev.online`
3. **SSL Certificates**: Set up proper SSL certificates for production
4. **Monitoring**: Set up DNS monitoring and health checks

## 🎯 Expected Results

Once configured, you should be able to access:

- **Staging**: `http://staging.softradev.online`
- **CloudFront**: `http://d2hpzrnlwvvw8x.cloudfront.net`
- **Load Balancer**: `http://aws-advance-infra-staging-alb-*.elb.amazonaws.com`

All should serve the same content through your CloudFront CDN! 🚀
