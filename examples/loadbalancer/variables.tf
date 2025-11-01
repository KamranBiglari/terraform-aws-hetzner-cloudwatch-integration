variable "hetzner_cloud_api_token" {
  description = "API token for Hetzner Cloud"
  type        = string
  sensitive   = true
}

variable "loadbalancer_id" {
  description = "Hetzner Cloud Load Balancer ID"
  type        = string
}