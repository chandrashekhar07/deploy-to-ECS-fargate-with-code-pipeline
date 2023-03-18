variable "namespace" {
  type        = string
  description = "namespace name"
}

variable "vpc_id" {
  type        = string
  description = "vpc id"
  default     = "vpc-0debb145d90130d22" # xxxx vpc
}

variable "port" {
  type        = number
  description = "port number"
  default     = 1337
}

variable "health_check_path" {
  type        = string
  description = "health check path"
  default     = "/"
}

variable "alb_name" {
  type        = string
  description = "alb arn"
  default     = "xxxx-dev-alb"

}

variable "subnets_count" {
  type        = number
  description = "subnets count"
  default     = 2
}

variable "cloudflare_email" {
  type        = string
  description = "value of cloudflare email"
}

variable "cloudflare_api_key" {
  type        = string
  description = "value of cloudflare api key"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "value of cloudflare zone id"

}

variable "db_security_group_id" {
  type        = string
  description = "value of db security group id"
  default     = "sg-0f9bfc92417f7db03" # xxxx psql db security group
}


variable "artifact_store_location" {
  type        = string
  description = "artifact store location"
  default     = "codepipeline-us-east-1-211559516537"
}

variable "codestar_connection_name" {
  type        = string
  description = "codestar connection name"
  default     = "xxxx GitHub"
}

variable "repository_name" {
  type        = string
  description = "repository name"
  default     = "xxxx-llc/project-cms"
}


