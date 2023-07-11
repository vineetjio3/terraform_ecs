#ecs cluster security group 
resource "aws_security_group" "ecs_sg" {
    vpc_id      = aws_vpc.vpc_ecs.id

    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
        tags = {
    Name        = "ecs_sg"
    #Environment = var.app_environment
  }
}

#rds security group
resource "aws_security_group" "rds_sg" {
    vpc_id      = aws_vpc.vpc_ecs.id

    ingress {
        protocol        = "tcp"
        from_port       = 3306
        to_port         = 3306
        cidr_blocks     = ["0.0.0.0/0"]
        security_groups = [aws_security_group.ecs_sg.id]
    }

    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
        tags = {
    Name        = "rds_sg"
    #Environment = var.app_environment
  }
}


#Internal Load balancer Security Group
resource "aws_security_group" "internal_load_sg" {
  vpc_id = aws_vpc.vpc_ecs.id

  ingress {
    protocol        = "tcp"
    from_port       = 8080
    to_port         = 8080
    cidr_blocks     = ["0.0.0.0/0"]
    
  }

  egress {
    from_port   = 0
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = {
    Name        = "internal_load_sg"
    #Environment = var.app_environment
  }
}


#ecs service group
resource "aws_security_group" "service_security_group" {
  vpc_id = aws_vpc.vpc_ecs.id

    
  ingress {
    protocol        = "tcp"
    from_port       = 8080
    to_port         = 8080
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.internal_load_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "service-sg"
    #Environment = var.app_environment
  }

}