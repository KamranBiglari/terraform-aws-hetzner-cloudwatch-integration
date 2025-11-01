# Terraform AWS Hetzner CloudWatch Integration

This Terraform module enables seamless integration between Hetzner Cloud resources and AWS CloudWatch, allowing you to monitor your Hetzner infrastructure using AWS CloudWatch metrics.

## Features

- Fetch metrics from Hetzner Cloud API (Load Balancers and Servers)
- Store metrics in AWS CloudWatch for centralized monitoring
- Uses AWS Step Functions for reliable metric collection
- Supports both Load Balancer and Server metrics
- Configurable IAM roles and EventBridge connections
- Scheduled metric collection via AWS Step Functions

## Supported Metrics

### Load Balancer Metrics

- **Open Connections**: Number of currently open connections
- **Connections Per Second**: Rate of new connections
- **Requests Per Second**: HTTP/HTTPS requests processed per second
- **Bandwidth In/Out**: Network traffic in bytes per second

### Server Metrics

- **CPU**: CPU utilization percentage
- **Disk IOPS**: Read/write operations per second
- **Disk Bandwidth**: Disk read/write throughput in bytes per second
- **Network Bandwidth**: Network traffic in/out in bytes per second
- **Network Packets**: Packet count in/out per second

## Architecture

This module creates:

1. **AWS EventBridge Connection**: Securely stores your Hetzner Cloud API token
2. **AWS Step Functions State Machine**: Fetches metrics from Hetzner Cloud API
3. **IAM Role & Policy**: Provides necessary permissions for the state machine
4. **CloudWatch Metrics**: Stores metrics in custom namespaces (`HetznerLoadBalancer` or `HetznerServer`)

## Usage

### Load Balancer Monitoring

```hcl
module "loadbalancer_metrics" {
  source  = "kamranbiglari/hetzner-cloudwatch-integration/aws"
  version = "~> 1.0"

  hetzner_cloud_api_token = var.hetzner_api_token
  metric_type             = "loadbalancer"
  name                    = "hetzner-lb-metrics"

  # Enable automatic metric collection every 5 minutes
  create_scheduler    = true
  schedule_expression = "rate(5 minutes)"

  data = {
    loadbalancer_id = "123456"
  }
}
```

### Server Monitoring

```hcl
module "server_metrics" {
  source  = "kamranbiglari/hetzner-cloudwatch-integration/aws"
  version = "~> 1.0"

  hetzner_cloud_api_token = var.hetzner_api_token
  metric_type             = "server"
  name                    = "hetzner-server-metrics"

  # Enable automatic metric collection every 5 minutes
  create_scheduler    = true
  schedule_expression = "rate(5 minutes)"

  data = {
    server_id = "789012"
  }
}
```

### Using Existing EventBridge Connection

```hcl
module "server_metrics" {
  source  = "kamranbiglari/hetzner-cloudwatch-integration/aws"
  version = "~> 1.0"

  create_event_connection = false
  event_connection_arn    = "arn:aws:events:us-east-1:123456789012:connection/hetzner-api/abc123"

  metric_type = "server"
  name        = "hetzner-server-metrics"

  data = {
    server_id = "789012"
  }
}
```

### Using Existing IAM Role

```hcl
module "loadbalancer_metrics" {
  source  = "kamranbiglari/hetzner-cloudwatch-integration/aws"
  version = "~> 1.0"

  hetzner_cloud_api_token = var.hetzner_api_token
  create_role             = false
  role_arn                = "arn:aws:iam::123456789012:role/custom-sfn-role"

  metric_type = "loadbalancer"
  name        = "hetzner-lb-metrics"

  data = {
    loadbalancer_id = "123456"
  }
}
```

## Scheduling Metric Collection

The module includes built-in support for automatic metric collection using AWS EventBridge Scheduler.

### Using Built-in Scheduler (Recommended)

Simply set `create_scheduler = true` and specify your desired schedule:

```hcl
module "loadbalancer_metrics" {
  source  = "kamranbiglari/hetzner-cloudwatch-integration/aws"
  version = "~> 1.0"

  hetzner_cloud_api_token = var.hetzner_api_token
  metric_type             = "loadbalancer"
  name                    = "hetzner-lb-metrics"

  # Enable automatic metric collection
  create_scheduler    = true
  schedule_expression = "rate(5 minutes)"  # or use cron: "cron(0/5 * * * ? *)"

  data = {
    loadbalancer_id = "123456"
  }
}
```

### Using Existing Scheduler IAM Role

If you have an existing IAM role for the scheduler:

```hcl
module "loadbalancer_metrics" {
  source  = "kamranbiglari/hetzner-cloudwatch-integration/aws"
  version = "~> 1.0"

  hetzner_cloud_api_token = var.hetzner_api_token
  metric_type             = "loadbalancer"
  name                    = "hetzner-lb-metrics"

  # Use existing scheduler role
  create_scheduler      = true
  create_scheduler_role = false
  scheduler_role_arn    = "arn:aws:iam::123456789012:role/my-scheduler-role"
  schedule_expression   = "rate(5 minutes)"

  data = {
    loadbalancer_id = "123456"
  }
}
```

### Manual Invocation

If you prefer to invoke the state machine manually or use your own scheduling solution, simply omit the `create_scheduler` parameter (defaults to `false`).

## CloudWatch Metrics

### Accessing Metrics

Metrics are stored in CloudWatch under custom namespaces:

- **Load Balancers**: `HetznerLoadBalancer`
- **Servers**: `HetznerServer`

Each metric includes a dimension identifying the resource:
- Load Balancers: `LoadBalancerId`
- Servers: `ServerId`

### Example CloudWatch Query

Using AWS CLI to query CPU metrics for a server:

```bash
aws cloudwatch get-metric-statistics \
  --namespace HetznerServer \
  --metric-name CPU \
  --dimensions Name=ServerId,Value=789012 \
  --start-time 2025-01-01T00:00:00Z \
  --end-time 2025-01-01T01:00:00Z \
  --period 300 \
  --statistics Average
```

## Security Considerations

- **API Token**: Your Hetzner Cloud API token is securely stored in AWS Secrets Manager via EventBridge Connections
- **IAM Permissions**: The module follows the principle of least privilege
- **Namespace Restrictions**: CloudWatch permissions are scoped to specific namespaces

## Cost Considerations

- **Step Functions**: Charged per state transition (Express Workflows)
- **CloudWatch**: Charged per custom metric and API requests
- **Secrets Manager**: Minimal cost for storing the API token
- **EventBridge**: No additional cost for connections

Typical cost for monitoring one resource with 5-minute intervals: ~$1-2/month

## Troubleshooting

### State Machine Execution Failed

Check CloudWatch Logs for the Step Functions execution to see detailed error messages.

### No Metrics in CloudWatch

1. Verify the Hetzner Cloud API token is valid
2. Check that the resource ID (loadbalancer_id or server_id) is correct
3. Ensure the Step Functions state machine has been executed
4. Review IAM permissions for the state machine role

### Invalid Metric Data

Ensure your Hetzner Cloud resource has been running long enough to generate metrics (typically 5+ minutes).

## Examples

See the [examples](./examples) directory for complete working examples:

- [Load Balancer Monitoring](./examples/loadbalancer)
- [Server Monitoring](./examples/server)

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

Apache 2.0 Licensed. See LICENSE for full details.

## Acknowledgments

This module integrates with:
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
- [AWS Step Functions](https://aws.amazon.com/step-functions/)
- [AWS CloudWatch](https://aws.amazon.com/cloudwatch/)

---

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_connection) | resource |
| [aws_iam_role.sfn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.sfn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_sfn_state_machine.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_state_machine) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Controls whether resources should be created | `bool` | `true` | no |
| <a name="input_create_event_connection"></a> [create\_event\_connection](#input\_create\_event\_connection) | Controls whether the event connection should be created | `bool` | `true` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Controls whether the IAM role should be created | `bool` | `true` | no |
| <a name="input_data"></a> [data](#input\_data) | value | `map(string)` | n/a | yes |
| <a name="input_event_connection_arn"></a> [event\_connection\_arn](#input\_event\_connection\_arn) | ARN of the event connection | `string` | `null` | no |
| <a name="input_event_connection_name"></a> [event\_connection\_name](#input\_event\_connection\_name) | Name of the event connection | `string` | `null` | no |
| <a name="input_hetzner_cloud_api_token"></a> [hetzner\_cloud\_api\_token](#input\_hetzner\_cloud\_api\_token) | API token for Hetzner Cloud | `string` | `null` | no |
| <a name="input_metric_type"></a> [metric\_type](#input\_metric\_type) | Type of the metric | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of application | `string` | n/a | yes |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | ARN of the IAM role | `string` | `null` | no |
| <a name="input_role_prefix"></a> [role\_prefix](#input\_role\_prefix) | Prefix for the IAM role | `string` | `"hetzner-cloudwatch"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->