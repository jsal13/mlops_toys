# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "postgres-vpc"
  }
}

# Create public subnets in different AZs
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public-subnet-2"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Create route table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "main-rt"
  }
}

# Associate route table with subnets
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.main.id
}

# Create DB subnet group
resource "aws_db_subnet_group" "postgres" {
  name       = "postgres-subnet-group"
  subnet_ids = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  tags = {
    Name = "Postgres DB subnet group"
  }
}

# Create a security group for RDS
resource "aws_security_group" "postgres" {
  name        = "postgres"
  description = "Allow PostgreSQL inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "PostgreSQL from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Warning: Lock this down to your IP/VPC in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the RDS instance
resource "aws_db_instance" "postgres" {
  identifier        = "minimal-postgres"
  engine            = "postgres"
  engine_version    = "16.4"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "testdb"
  username = "postgres"
  password = var.dbpass

  skip_final_snapshot = true
  publicly_accessible = true
  apply_immediately = true

  vpc_security_group_ids = [aws_security_group.postgres.id]
  db_subnet_group_name   = aws_db_subnet_group.postgres.name

  # Backup configuration
  backup_retention_period = 7
}

# Create a subnet group specifically for Aurora
resource "aws_db_subnet_group" "aurora" {
  name       = "aurora-subnet-group"
  subnet_ids = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  tags = {
    Name = "Aurora DB subnet group"
  }
}

# Create a security group for Aurora
resource "aws_security_group" "aurora" {
  name        = "aurora-postgres"
  description = "Allow PostgreSQL inbound traffic for Aurora"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "PostgreSQL from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Warning: Lock this down to your IP/VPC in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the Aurora cluster as a read replica
resource "aws_rds_cluster" "aurora_replica" {
  cluster_identifier      = "aurora-replica"
  engine                  = "aurora-postgresql"
  engine_mode            = "provisioned"

  # Reference the source RDS instance
  replication_source_identifier = aws_db_instance.postgres.arn
  source_region                = "us-east-1"

  # Network configuration
  db_subnet_group_name    = aws_db_subnet_group.aurora.name
  vpc_security_group_ids  = [aws_security_group.aurora.id]

  # Backup configuration
  backup_retention_period = 7
  preferred_backup_window = "04:00-05:00"

  # Maintenance configuration
  preferred_maintenance_window = "mon:05:00-mon:06:00"

  # Skip final snapshot for easier cleanup (change for production)
  skip_final_snapshot     = true

  # Enable deletion protection for production
  deletion_protection     = false
}

# Create an Aurora instance in the cluster
resource "aws_rds_cluster_instance" "aurora_replica_instance" {
  identifier         = "aurora-replica-1"
  cluster_identifier = aws_rds_cluster.aurora_replica.id

  engine            = "aurora-postgresql"
  instance_class    = "db.t3.medium"  # Minimum instance size for Aurora

  publicly_accessible = true

  # Monitoring configuration
  # monitoring_interval = 30
  # monitoring_role_arn = aws_iam_role.rds_enhanced_monitoring.arn
}






# Create IAM role for enhanced monitoring
# resource "aws_iam_role" "rds_enhanced_monitoring" {
#   name               = "rds-enhanced-monitoring-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "monitoring.rds.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# # Attach the enhanced monitoring policy to the role
# resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
#   role       = aws_iam_role.rds_enhanced_monitoring.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
# }
