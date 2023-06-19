output "main_cluster" {
  value = aws_ecs_cluster.main
}

output "service-taskDefinition" {
  value = aws_ecs_task_definition.service-taskDefinition
}