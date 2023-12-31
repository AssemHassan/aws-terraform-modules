resource "aws_ecs_cluster" "main" {
  name = "${var.namespace}-cluster"
}

resource "aws_ecs_task_definition" "service-taskDefinition" {
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  runtime_platform {
    cpu_architecture = "X86_64"  
    operating_system_family = "LINUX"
  }
  family = "${var.namespace}-${var.servicename}-taskDefinition"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn
  container_definitions = jsonencode(
      [
        {
          name        = "${var.container_name}"
          image       = "${var.container_image}"
          essential   = true
          portMappings = [{
            protocol      = "tcp"
            containerPort = var.container_port
            hostPort      = var.container_host_port
          }] 
        }
      ]
  )
}
