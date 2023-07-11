variable "aws_region" {
  default = "ap-south-1"
}

variable "vpc_cidr_ecs" {
  default = "10.13.0.0/16"
}

variable "ecs_public_subnets_cidr" {
  type    = list(any)
  default = ["10.13.1.0/24", "10.13.2.0/24"]
}

variable "ecs_private_subnets_cidr" {
  type    = list(any)
  default = ["10.13.3.0/24", "10.13.4.0/24"]
}

variable "azs_ecs" {
  type    = list(any)
  default = ["ap-south-1a", "ap-south-1c"]
}
variable "ingressCIDRblock" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}
variable "egressCIDRblock" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}
variable "destinationCIDRblock" {
  default = "0.0.0.0/0"
}

variable "app_name" {
  type    = string
  default = "worker"
}

#variable "app_environment" {
  #type        = string
  #description = "test"
#}

variable "allocated_storage" {
  default     = "10"
  description = "10GB"
}

variable "instance_class" {
  default     = "db.t3.micro"
  description = "db.t3.micro"
}

/* variable "multi_az" {
  default     = false
  description = "Muti-az allowed?"
} */

variable "database_name" {
  default     = "dummy_data"
  description = "dummy_data"
}

variable "database_username" {
  default     = "admin"
  description = "admin"
}

variable "database_password" {
  default     = "admin123"
  description = "admin123"
}

variable "ecs-cluster-name" {
    default = "ECS-Cluster"
}

variable "ecs-service-role-arn" {
    default = "demo-ecs-cluster"
}

variable "ecs-service-name" {
    default = "demo-ecs-service"
}

variable "ecs-load-balancer-name" {
    default = "demo-ecs-load-balancer"
}

variable "ecs_service_role_name" {
  default = "ecs-service-role"
}