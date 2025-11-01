# Load Balancer Metrics Example

This example demonstrates how to monitor Hetzner Cloud Load Balancer metrics using AWS CloudWatch.

## What This Example Does

- Creates a Step Functions state machine to fetch Load Balancer metrics from Hetzner Cloud API
- Stores metrics in AWS CloudWatch under the `HetznerLoadBalancer` namespace
- Automatically schedules metric collection every 5 minutes using the module's built-in scheduler

## Metrics Collected

- **Open Connections**: Number of currently open connections
- **Connections Per Second**: Rate of new connections
- **Requests Per Second**: HTTP/HTTPS requests processed per second
- **Bandwidth In**: Incoming network traffic in bytes per second
- **Bandwidth Out**: Outgoing network traffic in bytes per second

## Prerequisites

- Terraform >= 1.0
- AWS account with appropriate permissions
- Hetzner Cloud account with a Load Balancer
- Hetzner Cloud API token

## Usage

1. Create a `terraform.tfvars` file:

```hcl
hetzner_cloud_api_token = "your-hetzner-api-token-here"
loadbalancer_id         = "123456"
```

2. Initialize and apply:

```bash
terraform init
terraform plan
terraform apply
```

3. To view metrics in CloudWatch:

```bash
# List available metrics
aws cloudwatch list-metrics --namespace HetznerLoadBalancer

# Get CPU metrics for the last hour
aws cloudwatch get-metric-statistics \
  --namespace HetznerLoadBalancer \
  --metric-name OpenConnections \
  --dimensions Name=LoadBalancerId,Value=123456 \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 300 \
  --statistics Average
```

## Clean Up

```bash
terraform destroy
```

## Cost Estimate

Approximate monthly costs for this example:

- Step Functions (Express): ~$0.50/month (assuming 5-minute intervals)
- CloudWatch Custom Metrics: ~$0.30/month (5 metrics)
- Secrets Manager: ~$0.40/month
- EventBridge Scheduler: Free tier

**Total**: ~$1.20/month
