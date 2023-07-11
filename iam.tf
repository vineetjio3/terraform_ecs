#Creating ecs instance role
resource "aws_iam_role" "ecs-instance-role" {
  name = "ecs-instance-role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-policy" {
  role       = aws_iam_role.ecs-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


resource "aws_iam_instance_profile" "container_instance" {
  name = aws_iam_role.ecs-instance-role.name
  role = aws_iam_role.ecs-instance-role.name
}

# ECS Service IAM permissions
resource "aws_iam_role" "ecs-service-role" {
    name                = "ecs-service-role"
    path                = "/"
    assume_role_policy  = "${data.aws_iam_policy_document.ecs-service-policy.json}"
}

data "aws_iam_policy_document" "ecs-service-policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ecs.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
    role       = "${aws_iam_role.ecs-service-role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
    
}

#launch configuration
resource "aws_launch_configuration" "Ecs_launch_config" {
    name_prefix          = "worker"
    image_id             = "ami-006935d9a6773e4ec"
    iam_instance_profile =  aws_iam_instance_profile.container_instance.arn
    security_groups      = [aws_security_group.ecs_sg.id]
    instance_type        = "t3.micro"
    ebs_optimized        = "false"
    #source_dest_check    = "false"
    user_data            = data.template_file.user_data.rendered
    root_block_device {
    volume_type          = "gp2"
    volume_size          = "30"
    
   }

}

data "template_file" "user_data" {
  template = file("user_data.tpl") #Defines a script that runs when the EC2 instance starts
}


#Auto scaling 
resource "aws_autoscaling_group" "asg" {
    name                      = "asg"
    vpc_zone_identifier       = aws_subnet.ecs_private_subnet.*.id
    launch_configuration      = aws_launch_configuration.Ecs_launch_config.name
    protect_from_scale_in     = true

    desired_capacity          = 2
    min_size                  = 1
    max_size                  = 10
    health_check_grace_period = 300
    health_check_type         = "EC2"
 
  tag {
    key                 = "Name"
    value               = "ecs-instance"
    propagate_at_launch = true
  }
    tag {
    key = "AmazonECSManaged"
    value = ""
    propagate_at_launch = true
  }
}


#capacity provider
resource "aws_ecs_capacity_provider" "capacity_provider" {
  name =  "capacity_provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 4
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 2
    }
  } 
}

resource "aws_ecs_cluster_capacity_providers" "cluster" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = [aws_ecs_capacity_provider.capacity_provider.name]

  default_capacity_provider_strategy {
    base = 1
    weight = 100
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
  }
}


 #capacity provider
# resource "aws_ecs_capacity_provider" "capacity_provider" {
#   name =  "capacity_provider"

#   auto_scaling_group_provider {
#     auto_scaling_group_arn         = aws_autoscaling_group.asg.arn
#     managed_termination_protection = "ENABLED"

#     managed_scaling {
#       maximum_scaling_step_size = 1000
#       minimum_scaling_step_size = 1
#       status                    = "ENABLED"
#       target_capacity           = 10
#     }
#   } 
# }

/*   provisioner "local-exec" {
    when = destroy

    command = "aws ecs put-cluster-capacity-providers --cluster ecs_cluster  --capacity-providers [] --default-capacity-provider-strategy []"
  } */ 
