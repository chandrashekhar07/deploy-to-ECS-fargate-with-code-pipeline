locals {
  container_name = "${var.namespace}-${var.stage}-container"
  container_definition = jsonencode([{
    logConfiguration = {
      logDriver     = "awslogs",
      secretOptions = null,
      options = {
        awslogs-group         = aws_cloudwatch_log_group.loggroup.name,
        awslogs-region        = "us-east-1",
        awslogs-stream-prefix = "ecs"
      }
    }
    command    = null
    entryPoint = null
    portMappings = [
      {
        containerPort : var.port,
        hostPort : var.port,
      }
    ]

    environment = [for k, v in var.environment_variables : {
      name  = k,
      value = v
    }]
    image     = "${var.repository_url}:latest"
    essential = true
    name      = local.container_name
  }])
}


resource "aws_cloudwatch_log_group" "loggroup" {
  name = "${var.namespace}-${var.stage}-loggroup"
}


# Create ECS task definition
resource "aws_ecs_task_definition" "td" {
  container_definitions = local.container_definition

  family                   = "${var.namespace}-${var.stage}-task-definition"
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = null
  }
}
