terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  cloud {
    organization = "patricia-cloud"

    workspaces {
      name = "tf-s3-lambda"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  tags = {
    tier = "public"
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

resource "aws_security_group" "web_access" {
  name        = "WebAccess"
  description = "Allow HTTP to web server"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "bucket_lambda" {
  bucket = var.bucket_name
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket_lambda.id
  key    = var.s3_object_key
  source = var.s3_object_source
  source_hash = filemd5(var.s3_object_source)
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = var.policy_principal_type
      identifiers = [var.policy_principal_identifier]
    }

    actions = [var.policy_actions]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "policy_lambda" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "policy_s3" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_lambda_function" "lambda_hello_world_function" {
  function_name    = var.lambda_function_name
  role             = aws_iam_role.iam_for_lambda.arn
  runtime          = var.lambda_function_runtime
  s3_bucket        = aws_s3_bucket.bucket_lambda.id
  s3_key           = aws_s3_object.object.key
  handler          = var.lambda_function_handler
  source_code_hash = filebase64sha256(aws_s3_object.object.source)
  publish = true
}

resource "aws_lambda_permission" "lambda_with_alb" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_hello_world_function.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.tg_alb.arn
}

resource "aws_lb_target_group" "tg_alb" {
  name        = var.tg_name
  port        = var.tg_alb_port
  protocol    = var.tg_alb_protocol
  target_type = var.tg_alb_target_type
  vpc_id      = data.aws_vpc.default.id

  health_check {
    path     = "/"
    matcher  = "200"
    timeout  = 10
    interval = 30
  }
}

resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = var.alb_internal
  load_balancer_type = var.alb_type
  security_groups    = [aws_security_group.web_access.id]
  subnets            = [for subnet in data.aws_subnet.public : subnet.id]
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.alb_listener_port
  protocol          = var.alb_listener_protocol

  default_action {
    type             = var.alb_listener_default_action
    target_group_arn = aws_lb_target_group.tg_alb.arn
  }
}

resource "aws_lb_target_group_attachment" "lambda_alb_attach" {
  target_group_arn = aws_lb_target_group.tg_alb.arn
  target_id        = aws_lambda_function.lambda_hello_world_function.arn
  depends_on       = [aws_lambda_permission.lambda_with_alb]
}