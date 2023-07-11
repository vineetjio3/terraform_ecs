/*   resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "rds-subnet-group"
  description = "RDS subnet group"
  subnet_ids  = aws_subnet.ecs_private_subnet.*.id
  tags = {
    #Environment = "${var.environment}"
  }
} 


resource "aws_db_instance" "mysql" {
    identifier                = "mysql"
    allocated_storage         = 5
    backup_retention_period   = 2
    backup_window             = "01:00-01:30"
    maintenance_window        = "sun:03:00-sun:03:30"
    multi_az                  = true
    engine                    = "mysql"
    engine_version            = "5.7"
    instance_class            = "db.t3.micro"
    #name                      = "worker_db"
    username                  = "admin"
    password                  = "admin1234"
    port                      = "3306"
    db_subnet_group_name      = aws_db_subnet_group.rds_subnet_group.id
    vpc_security_group_ids    = [aws_security_group.rds_sg.id]
    skip_final_snapshot       = true
    final_snapshot_identifier = "worker-final"
    publicly_accessible       = false
}  */