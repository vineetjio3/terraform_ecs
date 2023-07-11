# VPC
resource "aws_vpc" "vpc_ecs" {
  cidr_block = var.vpc_cidr_ecs
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc_ecs"
  }
}


# Public subnets creating
resource "aws_subnet" "ecs_public_subnet" {
  count                   = length(var.ecs_public_subnets_cidr)
  vpc_id                  = aws_vpc.vpc_ecs.id
  cidr_block              = element(var.ecs_public_subnets_cidr, count.index)
  availability_zone       = element(var.azs_ecs, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "ecs_public_subnet-${count.index + 1}"
  }
}

# Private Subnets creating
resource "aws_subnet" "ecs_private_subnet" {
  count                   = length(var.ecs_private_subnets_cidr)
  vpc_id                  = aws_vpc.vpc_ecs.id
  cidr_block              = element(var.ecs_private_subnets_cidr, count.index)
  availability_zone       = element(var.azs_ecs, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "ecs_private_subnet-${count.index + 1}"
  }
}

# Internet Gateway creating
resource "aws_internet_gateway" "ecs-igw" {
  vpc_id = aws_vpc.vpc_ecs.id
  tags = {
    Name = "ecs-igw"
  }
} 
 
# Public Route table: attach Internet Gateway 
resource "aws_route_table" "ecs_public_rt" {
  vpc_id = aws_vpc.vpc_ecs.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs-igw.id
  }
  tags = {
    Name = "ecs_public_rt"
  }
}

# Private Route table
resource "aws_route_table" "ecs_private_rt" {
  vpc_id = aws_vpc.vpc_ecs.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs-igw.id
  }
  tags = {
    Name = "ecs_private_rt"

  }
}

# Route table association with public subnets
resource "aws_route_table_association" "a" {
  count          = length(var.ecs_public_subnets_cidr)
  subnet_id      = element(aws_subnet.ecs_public_subnet.*.id, count.index)
  route_table_id = aws_route_table.ecs_public_rt.id
}

# Route table association with private subnets
resource "aws_route_table_association" "b" {
  count          = length(var.ecs_private_subnets_cidr)
  subnet_id      = element(aws_subnet.ecs_private_subnet.*.id, count.index)
  route_table_id = aws_route_table.ecs_private_rt.id
}


resource "aws_db_subnet_group" "subnet_group_rds" {
  name        = "subnet_group_rds"
  description = "subnet_group_rds"
  subnet_ids  = aws_subnet.ecs_private_subnet.*.id
  tags = {
    #Environment = "${var.environment}"
  }
}

