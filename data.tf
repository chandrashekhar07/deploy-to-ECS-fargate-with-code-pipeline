locals {
  stage      = terraform.workspace
  api_prefix = terraform.workspace == "prod" ? "api" : "dev-api"
}


data "cloudflare_zone" "zone" {
  zone_id = var.cloudflare_zone_id
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

data "aws_alb" "xxxx" {
  name =  var.alb_name
}

#Retrieve secrets from AWS Secrets Manager
data "aws_secretsmanager_secret" "secrets" {
  name = "${var.namespace}/${local.stage}"
}

data "aws_secretsmanager_secret_version" "secrets" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}



data "aws_lb_listener" "xxxx" {
  load_balancer_arn = data.aws_alb.xxxx.arn
  port              = 80
}
