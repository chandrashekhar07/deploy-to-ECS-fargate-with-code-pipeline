resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.namespace}-${var.stage}-ecs-cluster"
}
