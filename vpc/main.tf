terraform {
  required_providers {
    aws = {
      version = "~> 3.31.0"
    }
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.env
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.env
  }
}

resource "aws_cloudwatch_log_group" "vpcflow" {
  name              = "${var.env}-vpcflow"
  retention_in_days = 30
}

data "aws_iam_policy_document" "vpcflow_assume" {
  statement {
    sid     = "AllowVpcAssume"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "vpcflow" {
  name               = "${var.env}-vpcflowlogs"
  assume_role_policy = data.aws_iam_policy_document.vpcflow_assume.json
}

data "aws_iam_policy_document" "vpcflow_policy" {
  statement {
    sid    = "AllowDescribeStream"
    effect = "Allow"

    actions = [
      "logs:DescribeLogGroups",
    ]

    resources = [
      aws_cloudwatch_log_group.vpcflow.arn,
    ]
  }

  statement {
    sid    = "AllowLogStreamsAndEvents"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "${aws_cloudwatch_log_group.vpcflow.arn}:*",
    ]
  }
}

resource "aws_iam_role_policy" "vpcflow_policy" {
  name   = "vpcflow_policy"
  role   = aws_iam_role.vpcflow.id
  policy = data.aws_iam_policy_document.vpcflow_policy.json
}

resource "aws_flow_log" "main" {
  vpc_id          = aws_vpc.main.id
  log_destination = aws_cloudwatch_log_group.vpcflow.arn
  iam_role_arn    = aws_iam_role.vpcflow.arn
  traffic_type    = "REJECT"
}

resource "aws_default_security_group" "main" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.env
  }
}
