variable "namespace" {
  description = "value for namespace tag"
  type        = string
}

variable "stage" {
  description = "value for stage eg. dev, prod, etc."
  type        = string
}


variable "task_role_arn" {
  description = "The ARN of the IAM role that allows your Amazon ECS container task to make calls to other AWS services."
  type        = string
}

variable "execution_role_arn" {
  description = "The ARN of the IAM role that allows your Amazon ECS container task to make calls to other AWS services."
  type        = string

}

variable "repository_url" {
  description = "The repository_url to use for the container."
  type        = string
}

variable "environment_variables" {
  description = "The environment variables to pass to the container."
  type        = map(string)
  default     = {}
}

variable "port" {
  description = "The port to use for the container."
  type        = number
}
