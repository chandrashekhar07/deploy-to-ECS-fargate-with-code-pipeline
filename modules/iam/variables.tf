variable "namespace" {
  type        = string
  description = "Namespace,project name, or application name"
}

variable "stage" {
  type        = string
  description = "Stage, e.g. 'prod', 'staging', 'dev', or 'test'"
}

variable "bucket_arn" {
  type        = string
  description = "The ARN of the S3 bucket"
}

