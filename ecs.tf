resource "aws_ecs_cluster" "ecs_cluster" {
    name  = "ecs_cluster"  
    tags = {
          key          = "ecs"
          value        = "cluster"
       }
}




