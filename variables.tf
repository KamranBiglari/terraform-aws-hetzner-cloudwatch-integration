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

variable "role_prefix" {
  description = "Prefix for the IAM role"
  type        = string
  default     = "hetzner-cloudwatch"
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

variable "name" {
  description = "Name of application"
  type        = string
}

# Scheduler variables
variable "create_scheduler" {
  description = "Controls whether the EventBridge Scheduler should be created"
  type        = bool
  default     = false
}

variable "schedule_expression" {
  description = "Schedule expression for the EventBridge Scheduler (e.g., 'rate(5 minutes)')"
  type        = string
  default     = "rate(5 minutes)"
}

variable "create_scheduler_role" {
  description = "Controls whether the IAM role for the scheduler should be created"
  type        = bool
  default     = true
}

variable "scheduler_role_arn" {
  description = "ARN of an existing IAM role for the scheduler. Required if create_scheduler_role is false"
  type        = string
  default     = null
}