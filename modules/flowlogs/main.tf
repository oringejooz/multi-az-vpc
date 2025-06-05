resource "aws_cloudwatch_log_group" "vpc_logs" {
  name              = "/aws/vpc/flow-logs"
  retention_in_days = 30
}

resource "aws_iam_role" "flow_logs_role" {
  name = "vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "flow_logs_policy" {
  name   = "vpc-flow-logs-policy"
  role   = aws_iam_role.flow_logs_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "logs:CreateLogStream"
      Resource = "${aws_cloudwatch_log_group.vpc_logs.arn}:*"
    },
    {
      Effect   = "Allow"
      Action   = "logs:PutLogEvents"
      Resource = "${aws_cloudwatch_log_group.vpc_logs.arn}:*"
    }]
  })
}

resource "aws_flow_log" "vpc_flow_logs" {
  log_destination      = aws_cloudwatch_log_group.vpc_logs.arn
  iam_role_arn         = aws_iam_role.flow_logs_role.arn
  vpc_id               = var.vpc_id
  traffic_type         = "ALL"
  log_destination_type = "cloud-watch-logs"
  log_format = "$${version} $${interface-id} $${srcaddr} $${dstaddr} $${action} $${log-status}"

  tags = {
    Name = "VPC-Flow-Logs"
  }
}



