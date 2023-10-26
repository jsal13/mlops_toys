locals {
  ami_name          = "ami-053b0d53c279acc90" //Ubuntu
  num_ec2_instances = 2
}

resource "random_string" "suffix" {
  count   = local.num_ec2_instances
  length  = 4
  special = false
  upper   = false
}

module "instances" {
  count  = local.num_ec2_instances
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.app_name}-ec2-${random_string.suffix[count.index].result}"

  #   create_spot_instance = true
  #   spot_price           = "0.60"
  #   spot_type            = "persistent"

  ami                    = local.ami_name
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
  subnet_id              = module.vpc.public_subnets[0]
}
