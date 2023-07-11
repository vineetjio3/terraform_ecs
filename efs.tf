resource "aws_efs_file_system" "mysql-data" {
  creation_token = "es-persistent-data"
  performance_mode = "generalPurpose"

  tags ={
    Name = "mysql-data"
  }
}

#efs 
resource "aws_efs_mount_target" "mysql-tg" {
  count  = "2"
  file_system_id  = "${aws_efs_file_system.mysql-data.id}"
  subnet_id      = element(aws_subnet.ecs_private_subnet.*.id, count.index)
  
  /* default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  } */
}

