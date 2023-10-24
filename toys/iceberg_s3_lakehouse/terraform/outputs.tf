output "s3_data_bucket_loc" {
  value = "s3://${module.s3_bucket_data.s3_bucket_id}"
}

# VPC Module Output Subset
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = module.vpc.vpc_ipv6_cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "public_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of public subnets in an IPv6 enabled VPC"
  value       = module.vpc.public_subnets_ipv6_cidr_blocks
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

output "database_subnet_arns" {
  description = "List of ARNs of database subnets"
  value       = module.vpc.database_subnet_arns
}

output "database_subnets_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = module.vpc.database_subnets_cidr_blocks
}

output "database_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of database subnets in an IPv6 enabled VPC"
  value       = module.vpc.database_subnets_ipv6_cidr_blocks
}

output "database_subnet_group" {
  description = "ID of database subnet group"
  value       = module.vpc.database_subnet_group
}

output "database_subnet_group_name" {
  description = "Name of database subnet group"
  value       = module.vpc.database_subnet_group_name
}

output "redshift_subnets" {
  description = "List of IDs of redshift subnets"
  value       = module.vpc.redshift_subnets
}

output "redshift_subnet_arns" {
  description = "List of ARNs of redshift subnets"
  value       = module.vpc.redshift_subnet_arns
}

output "redshift_subnets_cidr_blocks" {
  description = "List of cidr_blocks of redshift subnets"
  value       = module.vpc.redshift_subnets_cidr_blocks
}

output "redshift_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of redshift subnets in an IPv6 enabled VPC"
  value       = module.vpc.redshift_subnets_ipv6_cidr_blocks
}

output "redshift_subnet_group" {
  description = "ID of redshift subnet group"
  value       = module.vpc.redshift_subnet_group
}

output "elasticache_subnets" {
  description = "List of IDs of elasticache subnets"
  value       = module.vpc.elasticache_subnets
}

output "elasticache_subnet_arns" {
  description = "List of ARNs of elasticache subnets"
  value       = module.vpc.elasticache_subnet_arns
}

output "elasticache_subnets_cidr_blocks" {
  description = "List of cidr_blocks of elasticache subnets"
  value       = module.vpc.elasticache_subnets_cidr_blocks
}

output "elasticache_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of elasticache subnets in an IPv6 enabled VPC"
  value       = module.vpc.elasticache_subnets_ipv6_cidr_blocks
}

output "intra_route_table_ids" {
  description = "List of IDs of intra route tables"
  value       = module.vpc.intra_route_table_ids
}

output "public_internet_gateway_route_id" {
  description = "ID of the internet gateway route"
  value       = module.vpc.public_internet_gateway_route_id
}

output "public_internet_gateway_ipv6_route_id" {
  description = "ID of the IPv6 internet gateway route"
  value       = module.vpc.public_internet_gateway_ipv6_route_id
}
