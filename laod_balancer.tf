#Creating Internal-load balancer

resource "aws_alb" "Internal_alb" {
  name               = "Internal-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = aws_subnet.ecs_private_subnet.*.id
  security_groups    = [aws_security_group.internal_load_sg.id]

  tags = {
    Name        = "Internal_alb"
    #Environment = var.app_environment
  }
}

#Target Group

resource "aws_lb_target_group" "target_group" {
  name        = "internal-lb-tg"
  port        = 80
  protocol    = "HTTP"
  #target_type = "ip"
  vpc_id      = aws_vpc.vpc_ecs.id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/v1/status"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "internal-lb-tg"
    #Environment = var.app_environment
  }
}

#Creating Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.Internal_alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}

# Auto Scaling Group

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.aws-ecs-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "app-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 80
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "internal-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 80
  }
}

#Cloudwatch group
resource "aws_cloudwatch_log_group" "log-group" {
  name = "key-logs"

  tags = {
    Application = "key-logs"
    #Environment = var.app_environment
  }
}
