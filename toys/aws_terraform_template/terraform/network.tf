module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "${local.app_name}-vpn"

  azs            = var.azs
  public_subnets = var.public_subnets

  # enable_ipv6                 = true
  # public_subnet_ipv6_native   = true
  # public_subnet_ipv6_prefixes = [0]

  # RDS currently only supports dual-stack so IPv4 CIDRs will need to be provided for subnets
  # database_subnet_ipv6_native   = true
  # database_subnet_ipv6_prefixes = [6, 7, 8]

  create_egress_only_igw = true
}
