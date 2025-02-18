# output "aurora_cluster_endpoint" {
#   value = aws_rds_cluster.aurora_replica.endpoint
# }

# output "aurora_reader_endpoint" {
#   value = aws_rds_cluster.aurora_replica.reader_endpoint
# }

output "source_rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}