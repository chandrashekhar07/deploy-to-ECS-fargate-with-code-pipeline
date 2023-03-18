variable "vpc_id" {
  description = "value of vpc id"
  type        = string
}

variable "cidr_blocks" {
  description = "value of cidr blocks"
  type        = list(string)
}

variable "from_port" {
  description = "value of from port"
  type        = number
}

variable "to_port" {
  description = "value of to port"
  type        = number
}

variable "description" {
  description = "value of description"
  type        = string
  default     = ""
}

variable "name" {
  description = "value of name"
  type        = string
}


variable "security_groups" {
  description = "value of security group id"
  type        = list(string)
}
