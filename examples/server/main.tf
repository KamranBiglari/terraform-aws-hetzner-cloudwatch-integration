terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "server_metrics" {
  source = "../.."

  hetzner_cloud_api_token = var.hetzner_cloud_api_token
  metric_type             = "server"
  name                    = "hetzner-server-metrics"

  # Enable scheduler to automatically collect metrics every 5 minutes
  create_scheduler    = true
  schedule_expression = "rate(5 minutes)"

  data = {
    server_id = var.server_id
  }
}
