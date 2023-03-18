variable "namespace" {
  description = "value for namespace tag"
  type        = string
}

variable "stage" {
  description = "value for stage eg. dev, prod, etc."
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "alb_arn" {
  type        = string
  description = "alb arn"
}

variable "hosts" {
  type        = list(string)
  description = "list of hosts"
}


variable "alb_listener_arn" {
  type        = string
  description = "The ALB listener arn to attach listener"
}

variable "health_check_path" {
  type        = string
  description = "The health check path"
  default     = "/"
}

variable "port" {
  description = "The port to use for the container."
  type        = number
}

