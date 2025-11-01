output "state_machine_arn" {
  description = "ARN of the Step Functions state machine"
  value       = module.server_metrics.state_machine_arn
}

output "state_machine_name" {
  description = "Name of the Step Functions state machine"
  value       = module.server_metrics.state_machine_name
}

output "scheduler_schedule_arn" {
  description = "ARN of the EventBridge Scheduler schedule"
  value       = module.server_metrics.scheduler_schedule_arn
}

output "scheduler_role_arn" {
  description = "ARN of the scheduler IAM role"
  value       = module.server_metrics.scheduler_role_arn
}
