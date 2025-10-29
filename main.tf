resource "aws_cloudwatch_event_connection" "this" {
  count              = var.create && var.create_event_connection ? 1 : 0
  name               = var.event_connection_name
  description        = "Connection for calling the Hetzner Cloud API"
  authorization_type = "API_KEY"

  auth_parameters {
    api_key {
      key   = "Authorization"
      value = "Bearer ${var.hetzner_cloud_api_token}"
    }
  }
}

resource "aws_iam_role" "test_role" {
  count = var.create && var.create_role ? 1 : 0
  name  = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_sfn_state_machine" "this" {
  count    = var.create ? 1 : 0
  type     = "EXPRESS"
  role_arn = var.create_role ? aws_iam_role.test_role[0].arn : var.role_arn

  definition = templatefile("${path.module}/${local.metrics[var.metric_type].sfn_template}",
    merge(
      {
        connection_arn = var.create_event_connection ? aws_cloudwatch_event_connection.this[0].arn : var.event_connection_arn
      },
      var.data
    )
  )
}