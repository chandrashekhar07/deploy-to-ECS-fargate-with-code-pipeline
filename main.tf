
module "ecs_cluster" {
  source    = "./modules/ecs-cluster"
  namespace = var.namespace
  stage     = local.stage
}



module "ecr" {
  source   = "./modules/ecr"
  ecr_name = "${var.namespace}-${local.stage}-ecr"
}



module "s3" {
  source      = "./modules/s3"
  bucket_name = "${var.namespace}-${local.stage}-bucket"
}


module "iam" {
  source     = "./modules/iam"
  namespace  = var.namespace
  stage      = local.stage
  bucket_arn = module.s3.bucket_arn
}


module "task_definition" {
  source                = "./modules/ecs-task-definition"
  namespace             = var.namespace
  stage                 = local.stage
  repository_url        = module.ecr.repository_url
  execution_role_arn    = module.iam.ecs_task_execution_role_arn
  task_role_arn         = module.iam.task_role_arn
  environment_variables = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)
  port                  = var.port
}

module "alb" {
  source            = "./modules/alb"
  namespace         = var.namespace
  stage             = local.stage
  vpc_id            = data.aws_vpc.vpc.id
  alb_arn           = data.aws_alb.xxxx.arn
  hosts             = ["${local.api_prefix}.${data.cloudflare_zone.zone.name}"]
  alb_listener_arn  = data.aws_lb_listener.xxxx.arn
  health_check_path = var.health_check_path
  port              = var.port
}


module "ecs_service" {
  source               = "./modules/ecs-service"
  namespace            = var.namespace
  stage                = local.stage
  ecs_cluster_id       = module.ecs_cluster.ecs_cluster_id
  task_definition_arn  = module.task_definition.task_definition_arn
  subnets              = slice(data.aws_subnets.subnets.ids, 0, var.subnets_count)
  container_name       = module.task_definition.container_name
  alb_target_group_arn = module.alb.alb_target_group_arn
  port                 = var.port
  vpc_id               = data.aws_vpc.vpc.id
  alb_security_groups  = tolist(data.aws_alb.xxxx.security_groups)
  db_security_group_id = var.db_security_group_id

}


# Add a record to the Cloudflare DNS zone
resource "cloudflare_record" "dns_record" {
  zone_id = data.cloudflare_zone.zone.id
  name    = local.api_prefix
  value   = data.aws_alb.xxxx.dns_name
  type    = "CNAME"
  proxied = true
}

