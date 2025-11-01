variable "hetzner_cloud_api_token" {
  description = "API token for Hetzner Cloud"
  type        = string
  sensitive   = true
}

variable "server_id" {
  description = "Hetzner Cloud Server ID"
  type        = string
}
