output "task_definition_arn" {
  value = aws_ecs_task_definition.td.arn
}

output "container_name" {
  value = local.container_name
}