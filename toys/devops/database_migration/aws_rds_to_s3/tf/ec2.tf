# Create a security group for the EC2 instance
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Security group for EC2 instance with RDS access"
  vpc_id      = aws_vpc.database_vpc.id
  
  # Allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Better to restrict to your IP for production
  }
  
  # Allow HTTP access if needed
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow HTTPS access if needed
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "EC2 Security Group"
  }
}

# Update RDS security group to allow access from EC2 security group
resource "aws_security_group_rule" "rds_from_ec2" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ec2_sg.id
  security_group_id        = aws_security_group.database_sg.id
}

# Create a public subnet for the EC2 instance
resource "aws_subnet" "ec2_subnet" {
  vpc_id                  = aws_vpc.database_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a"  # Match with one of your DB subnets
  map_public_ip_on_launch = true
  
  tags = {
    Name = "EC2 Public Subnet"
  }
}

# Associate the EC2 subnet with the route table
resource "aws_route_table_association" "ec2_route_assoc" {
  subnet_id      = aws_subnet.ec2_subnet.id
  route_table_id = aws_route_table.database_route_table.id
}

# Create an IAM role for the EC2 instance
resource "aws_iam_role" "ec2_role" {
  name = "ec2-rds-access-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Create an IAM policy for SSM access (for easy management)
resource "aws_iam_policy" "ssm_policy" {
  name        = "ec2-ssm-policy"
  description = "Allow EC2 to use SSM"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach the SSM policy to the role
resource "aws_iam_role_policy_attachment" "ssm_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ssm_policy.arn
}

# Create an IAM instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-rds-access-profile"
  role = aws_iam_role.ec2_role.name
}

# Create a key pair for SSH access (or use an existing one)
resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-rds-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

# Create the EC2 instance
resource "aws_instance" "db_client" {
  ami                    = "ami-05b10e08d247fb927"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.ec2_key.key_name
  subnet_id              = aws_subnet.ec2_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  
  # Install PostgreSQL client and other utilities
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y postgresql15 jq aws-cli
    
    # Create a simple script to connect to the RDS instance
    cat > /home/ec2-user/connect-to-db.sh <<'SCRIPT'
    #!/bin/bash
    PGPASSWORD=${aws_db_instance.postgres.password} psql \
      -h ${aws_db_instance.postgres.endpoint} \
      -U ${aws_db_instance.postgres.username} \
      -d ${aws_db_instance.postgres.db_name} \
      -p ${aws_db_instance.postgres.port}
    SCRIPT
    
    chmod +x /home/ec2-user/connect-to-db.sh
    chown ec2-user:ec2-user /home/ec2-user/connect-to-db.sh
  EOF
  
  tags = {
    Name = "RDS Client EC2"
  }
  
  depends_on = [aws_db_instance.postgres]
}

# Outputs
output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.db_client.id
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.db_client.public_ip
}

output "db_connection_command" {
  description = "Command to connect to the database from the EC2 instance"
  value       = "ssh -i your-key.pem ec2-user@${aws_instance.db_client.public_ip} -t './connect-to-db.sh'"
}