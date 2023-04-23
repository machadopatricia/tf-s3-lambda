variable "region" {
  type    = string
  default = "us-east-1"
}

#### S3 BUCKET VARIABLES ####

variable "bucket_name" {
  type    = string
  default = "tf-bucket-for-lambda-function"
}

variable "s3_object_key" {
  type    = string
  default = "lambda-function"
}

variable "s3_object_source" {
  type    = string
  default = "lambda_hello_world_function.zip"
}

#### IAM VARIABLES ####

variable "policy_principal_type" {
  type    = string
  default = "Service"
}

variable "policy_principal_identifier" {
  type    = string
  default = "lambda.amazonaws.com"
}

variable "policy_actions" {
  type    = string
  default = "sts:AssumeRole"
}

variable "role_name" {
  type    = string
  default = "LambdaS3Role"
}

#### LAMBDA VARIABLES ####

variable "lambda_function_name" {
  type    = string
  default = "hello-world"
}

variable "lambda_function_runtime" {
  type    = string
  default = "nodejs14.x"
}

variable "lambda_function_handler" {
  type    = string
  default = "lambda_hello_world_function.handler"
}

#### TARGET GROUP VARIABLES ####

variable "tg_name" {
  type    = string
  default = "TG-ALB"
}

variable "tg_alb_port" {
  type    = number
  default = 80
}

variable "tg_alb_protocol" {
  type    = string
  default = "HTTP"
}

variable "tg_alb_target_type" {
  type    = string
  default = "lambda"
}

#### APPLICATION LOAD BALANCER VARIABLES ####

variable "alb_name" {
  type    = string
  default = "MyALB"
}

variable "alb_internal" {
  type    = bool
  default = false
}

variable "alb_type" {
  type    = string
  default = "application"
}

#### ALB LISTENER VARIABLES ####

variable "alb_listener_port" {
  type    = string
  default = "80"
}

variable "alb_listener_protocol" {
  type    = string
  default = "HTTP"
}

variable "alb_listener_default_action" {
  type    = string
  default = "forward"
}

