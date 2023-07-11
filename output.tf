
/* output "mysql_endpoint" {
    value = aws_db_instance.mysql.endpoint
} 
output "ecr_repository_worker_endpoint" {
    value = aws_ecr_repository.worker.repository_url
}

output "instance_id" {
  value = aws_instance.ec-instance.id
} 

output "ecs-load-balancer-name" {
  value = "${aws_alb.ecs-load-balancer.name}"
}

output "ecs-target-group-arn" {
  value = "${aws_alb_target_group.ecs-target_group.arn}"
} 


 output "ecs-instance-role-name" {
  value = "${aws_iam_role.ecs-instance-role.name}"
} 

output "ecs-service-role-arn" {
  value = "${aws_iam_role.ecs-service-role.arn}"
} */