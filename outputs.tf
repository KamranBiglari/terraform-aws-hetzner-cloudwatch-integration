output "state_machine_arn" {
  description = "ARN of the Step Functions state machine"
  value       = var.create ? aws_sfn_state_machine.this[0].arn : null
}

output "state_machine_name" {
  description = "Name of the Step Functions state machine"
  value       = var.create ? aws_sfn_state_machine.this[0].name : null
}

output "event_connection_arn" {
  description = "ARN of the EventBridge connection"
  value       = var.create && var.create_event_connection ? aws_cloudwatch_event_connection.this[0].arn : null
}

output "iam_role_arn" {
  description = "ARN of the IAM role used by the state machine"
  value       = var.create && var.create_role ? aws_iam_role.sfn[0].arn : null
}

output "scheduler_schedule_arn" {
  description = "ARN of the EventBridge Scheduler schedule"
  value       = var.create && var.create_scheduler ? aws_scheduler_schedule.this[0].arn : null
}

output "scheduler_role_arn" {
  description = "ARN of the IAM role used by the scheduler"
  value       = var.create && var.create_scheduler && var.create_scheduler_role ? aws_iam_role.scheduler[0].arn : null
}
