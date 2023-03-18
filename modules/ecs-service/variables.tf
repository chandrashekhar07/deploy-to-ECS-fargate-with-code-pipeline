variable "namespace" {
  description = "value for namespace tag"
  type        = string
}

variable "stage" {
  description = "value for stage eg. dev, prod, etc."
  type        = string
}

variable "ecs_cluster_id" {
  description = "The ECS cluster ID to run the service on."
  type        = string
}

variable "task_definition_arn" {
  description = "The ARN of the task definition to use for the service."
  type        = string
}

variable "subnets" {
  description = "The subnets to associate with the service."
  type        = list(string)
}

variable "alb_target_group_arn" {
  description = "The target group arn to attach listener"
  type        = string
}

variable "container_name" {
  description = "The container name to attach listener"
  type        = string
}

variable "port" {
  description = "The port to use for the container."
  type        = number
}

variable "vpc_id" {
  description = "value of vpc id"
  type        = string
}

variable "alb_security_groups" {
  description = "value of alb security group ids"
  type        = list(string)
}

variable "db_security_group_id" {
  description = "value of db security group id"
  type        = string
}


