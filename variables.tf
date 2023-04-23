variable "region" {
  type    = string
  default = "us-east-1"
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

