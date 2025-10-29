variable "create" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = true
}

variable "create_event_connection" {
  description = "Controls whether the event connection should be created"
  type        = bool
  default     = true
}

variable "hetzner_cloud_api_token" {
  description = "API token for Hetzner Cloud"
  type        = string
  default     = null
}

variable "event_connection_name" {
  type        = string
  description = "Name of the event connection"
  default     = null
}

variable "event_connection_arn" {
  type        = string
  description = "ARN of the event connection"
  default     = null
}

variable "create_role" {
  description = "Controls whether the IAM role should be created"
  type        = bool
  default     = true
}

variable "role_name" {
  description = "Name of the IAM role"
  type        = string
  default     = "test_role"
}

variable "role_arn" {
  description = "ARN of the IAM role"
  type        = string
  default     = null
}

variable "metric_type" {
  description = "Type of the metric"
  type        = string

  validation {
    condition     = var.metric_type != ""
    error_message = "Metric type must be specified"
  }

  validation {
    condition     = contains(["loadbalancer", "server"], var.metric_type)
    error_message = "Only loadbalancer and server accepted"
  }
}

variable "data" {
  description = "value"
  type        = map(string)
}