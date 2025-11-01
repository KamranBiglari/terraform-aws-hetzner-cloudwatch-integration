# Server Metrics Example

This example demonstrates how to monitor Hetzner Cloud Server metrics using AWS CloudWatch.

## What This Example Does

- Creates a Step Functions state machine to fetch Server metrics from Hetzner Cloud API
- Stores metrics in AWS CloudWatch under the `HetznerServer` namespace
- Automatically schedules metric collection every 5 minutes using the module's built-in scheduler

## Metrics Collected

- **CPU**: CPU utilization percentage
- **Disk IOPS Read**: Disk read operations per second
- **Disk IOPS Write**: Disk write operations per second
- **Disk Bandwidth Read**: Disk read throughput in bytes per second
- **Disk Bandwidth Write**: Disk write throughput in bytes per second
- **Network Bandwidth In**: Incoming network traffic in bytes per second
- **Network Bandwidth Out**: Outgoing network traffic in bytes per second
- **Network Packets In**: Incoming packets per second
- **Network Packets Out**: Outgoing packets per second

## Prerequisites

- Terraform >= 1.0
- AWS account with appropriate permissions
- Hetzner Cloud account with a Server
- Hetzner Cloud API token

## Usage

1. Create a `terraform.tfvars` file:

```hcl
hetzner_cloud_api_token = "your-hetzner-api-token-here"
server_id               = "789012"
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
aws cloudwatch list-metrics --namespace HetznerServer

# Get CPU metrics for the last hour
aws cloudwatch get-metric-statistics \
  --namespace HetznerServer \
  --metric-name CPU \
  --dimensions Name=ServerId,Value=789012 \
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
- CloudWatch Custom Metrics: ~$0.90/month (9 metrics)
- Secrets Manager: ~$0.40/month
- EventBridge Scheduler: Free tier

**Total**: ~$1.80/month
