resource "aws_ecs_service" "aws-ecs-service" {
  name                 =  "aws-ecs-service"
  cluster              =   aws_ecs_cluster.ecs_cluster.id
  #task_definition      =  data.template_file.task_definition_template.rendered
  task_definition      = "${aws_ecs_task_definition.task_definition.arn}"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true
  launch_type          = "EC2" 

 /*    network_configuration {
    #assign_public_ip = false
    #security_groups  = [aws_security_group.service_security_group.id]
    subnets          =  "${var.ecs_private_subnets_cidr[count.index].id}"
  }
   lifecycle {
    ignore_changes = [task_definition]
  }  */

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "worker"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.listener]
}

 