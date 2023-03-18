terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "xxxx-aws-core-terraform"
    key    = "project-cms-terraform.tfstate"
    region = "us-east-1"
  }
}
