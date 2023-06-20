resource "aws_lb" "internal_alb" {
  name               = "${var.namespace}-${var.servicename}-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.security_groups.*.id
  subnets            = var.container_subnets
 
  enable_deletion_protection = false
}

resource "aws_alb_target_group" "service-runtime" {
  name        = "${var.namespace}-${var.servicename}-tg"
  port        = var.container_host_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
 
  health_check {
   healthy_threshold   = "3"
   interval            = "30"
   protocol            = "HTTP"
   matcher             = "200"
   timeout             = "3"
   path                = var.health_check_path
   unhealthy_threshold = "2"
  }
}
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.internal_alb.id
  port              = var.container_host_port
  protocol          = "HTTP"
  
  default_action {
    target_group_arn = aws_alb_target_group.service-runtime.id
    type             = "forward"
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.internal_alb.id
  port              = "443"
  protocol          =  "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.cert_arn

  default_action {
    target_group_arn = aws_alb_target_group.service-runtime.id
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "listner_auth" {
  listener_arn = "${aws_alb_listener.https.arn}"

  action {
    type             = "authenticate-cognito"
    authenticate_cognito {
      user_pool_arn       = var.cognito_user_pool_arn 
      user_pool_client_id = var.cognito_user_pool_client_id
      user_pool_domain    = var.cognito_user_pool_domain
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service-runtime.id
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
 

resource "aws_ecs_service" "runtime_service" {
 name                               = "${var.namespace}-ecs-${var.servicename}"
 cluster                            = var.ecs_cluster.id
 task_definition                    = var.service-taskDefinition.arn
 desired_count                      = 1
 launch_type                        = "FARGATE"
 scheduling_strategy                = "REPLICA"
 
 network_configuration {
   security_groups  = var.security_groups.*.id
   subnets          = var.container_subnets 
   assign_public_ip = true # this is needed to be able to pull public images from ECR. Not needed if we have NAT gateway setup
 }
 
 load_balancer {
   target_group_arn = aws_alb_target_group.service-runtime.arn
   container_name   = "${var.container_name}"
   container_port   = var.container_port
 }
 
 lifecycle {
   ignore_changes = [task_definition, desired_count]
 }
}

resource "aws_appautoscaling_target" "autoscale_target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${var.ecs_cluster.name}/${aws_ecs_service.runtime_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "autoscale_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.autoscale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.autoscale_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.autoscale_target.service_namespace
 
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 50
  }
}

resource "aws_appautoscaling_policy" "autoscale_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.autoscale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.autoscale_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.autoscale_target.service_namespace
 
  target_tracking_scaling_policy_configuration {
   predefined_metric_specification {
     predefined_metric_type = "ECSServiceAverageCPUUtilization"
   }
   target_value       = 30
  }
}
