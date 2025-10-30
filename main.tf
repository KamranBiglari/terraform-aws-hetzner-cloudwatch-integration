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

resource "aws_iam_role" "sfn" {
  count = var.create && var.create_role ? 1 : 0
  name  = "${var.role_prefix}-sfn-role"

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
          Service = "states.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_role_policy" "sfn" {
  count = var.create && var.create_role ? 1 : 0
  name  = "${var.role_prefix}-sfn-policy"
  role  = aws_iam_role.sfn[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "states:InvokeHTTPEndpoint"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "events:RetrieveConnectionCredentials"
        ]
        Resource = var.create_event_connection ? aws_cloudwatch_event_connection.this[0].arn : var.event_connection_arn
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "arn:aws:secretsmanager:*:*:secret:events!connection/*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "cloudwatch:namespace" = "HetznerLoadBalancer"
          }
        }
      }
    ]
  })
}

resource "aws_sfn_state_machine" "this" {
  count    = var.create ? 1 : 0
  name     = "${var.name}"
  type     = "EXPRESS"
  role_arn = var.create_role ? aws_iam_role.sfn[0].arn : var.role_arn

  definition = templatefile("${path.module}/${local.metrics[var.metric_type].sfn_template}",
    merge(
      {
        connection_arn = var.create_event_connection ? aws_cloudwatch_event_connection.this[0].arn : var.event_connection_arn
      },
      var.data
    )
  )
}