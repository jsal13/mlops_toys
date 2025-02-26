# VPC for the database (You may use existing VPC)
resource "aws_vpc" "database_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Database VPC"
  }
}

# Create two subnets in different availability zones for the DB subnet group
resource "aws_subnet" "database_subnet_1" {
  vpc_id            = aws_vpc.database_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Database Subnet 1"
  }
}

resource "aws_subnet" "database_subnet_2" {
  vpc_id            = aws_vpc.database_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Database Subnet 2"
  }
}

# Create a DB subnet group
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "database-subnet-group"
  description = "DB subnet group for PostgreSQL"
  subnet_ids  = [aws_subnet.database_subnet_1.id, aws_subnet.database_subnet_2.id]

  tags = {
    Name = "Database Subnet Group"
  }
}

# Create a security group for the RDS instance
resource "aws_security_group" "database_sg" {
  name        = "database-security-group"
  description = "Security group for PostgreSQL RDS"
  vpc_id      = aws_vpc.database_vpc.id

  # Allow PostgreSQL traffic from within the VPC
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Optional: Allow connections from specific IP addresses
  # ingress {
  #   from_port   = 5432
  #   to_port     = 5432
  #   protocol    = "tcp"
  #   cidr_blocks = ["YOUR_IP_ADDRESS/32"]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Database Security Group"
  }
}

# Create an internet gateway to allow internet access
resource "aws_internet_gateway" "database_igw" {
  vpc_id = aws_vpc.database_vpc.id

  tags = {
    Name = "Database Internet Gateway"
  }
}

# Create a route table for public access
resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.database_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.database_igw.id
  }

  tags = {
    Name = "Database Route Table"
  }
}

# Associate the route table with the subnets
resource "aws_route_table_association" "database_route_assoc_1" {
  subnet_id      = aws_subnet.database_subnet_1.id
  route_table_id = aws_route_table.database_route_table.id
}

resource "aws_route_table_association" "database_route_assoc_2" {
  subnet_id      = aws_subnet.database_subnet_2.id
  route_table_id = aws_route_table.database_route_table.id
}

# Create a parameter group for PostgreSQL configuration
resource "aws_db_parameter_group" "postgres_params" {
  name        = "postgres-parameters"
  family      = "postgres14"
  description = "Custom parameter group for PostgreSQL"

#   parameter {
#     name  = "max_connections"
#     value = "100"
#   }

#   parameter {
#     name  = "shared_buffers"
#     value = "16384"
#   }
}

# Create the RDS PostgreSQL instance
resource "aws_db_instance" "postgres" {
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "14.12"
  instance_class          = "db.t3.micro"
  db_name                 = "mydatabase"
  username                = "dbadmin"
  password                = "example1234"
  db_subnet_group_name    = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.database_sg.id]
  parameter_group_name    = aws_db_parameter_group.postgres_params.name
  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "mon:04:00-mon:05:00"
  multi_az                = false

  tags = {
    Name = "PostgreSQL Database"
  }
}
