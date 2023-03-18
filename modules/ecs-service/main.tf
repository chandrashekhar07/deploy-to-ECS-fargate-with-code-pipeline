
module "security_group" {
  source          = "../sg"
  vpc_id          = var.vpc_id
  name            = "${var.namespace}-${var.stage}-ecs-sg"
  description     = "Security group for ECS"
  from_port       = var.port
  to_port         = var.port
  cidr_blocks     = []
  security_groups = var.alb_security_groups
}


# Create ecs_service
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.namespace}-${var.stage}-service"
  cluster         = var.ecs_cluster_id
  task_definition = var.task_definition_arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true
    security_groups  = [module.security_group.security_group_id]
  }


  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 0

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.container_name
    container_port   = var.port
  }




}


# Allow ECS security group to talk to  Database security group
resource "aws_security_group_rule" "ecs_to_db" {
  type                     = "ingress"
  from_port                = 54321
  to_port                  = 54321
  protocol                 = "tcp"
  source_security_group_id = module.security_group.security_group_id
  security_group_id        = var.db_security_group_id
  description              = "Allow ECS ${var.namespace}-${var.stage}"
}
