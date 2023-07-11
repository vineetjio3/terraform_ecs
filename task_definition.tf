 
resource "aws_ecs_task_definition" "task_definition" {
  family                   = "worker"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  container_definitions = "${file("${"${path.module}/task_definition.json"}")}" #data.template_file.task_definition_template.rendered 
 
        }

