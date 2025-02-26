# Outputs
output "s3_bucket_name" {
  description = "The name of the S3 bucket where database exports are stored"
  value       = aws_s3_bucket.db_export_bucket.id
}

# output "export_task_id" {
#   description = "The identifier of the export task"
#   value       = aws_db_snapshot_export_task.export_task.id
# }

# output "snapshot_arn" {
#   description = "The ARN of the database snapshot"
#   value       = aws_db_snapshot.db_snapshot.db_snapshot_arn
# }


# Outputs
output "rds_endpoint" {
  description = "The connection endpoint for the PostgreSQL instance"
  value       = aws_db_instance.postgres.endpoint
}

output "rds_port" {
  description = "The port the PostgreSQL instance is listening on"
  value       = aws_db_instance.postgres.port
}

output "rds_name" {
  description = "The database name"
  value       = aws_db_instance.postgres.db_name
}

output "rds_username" {
  description = "The master username for the database"
  value       = aws_db_instance.postgres.username
}
