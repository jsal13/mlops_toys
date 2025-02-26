# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# # Get existing RDS instance details
# # Uncomment and fill in your instance identifier
# # data "aws_db_instance" "database" {
# #   db_instance_identifier = "your-db-instance-name"
# # }

# # Create a DB snapshot (for exports)
# # Note: You might want to use a different approach for production systems
# resource "aws_db_snapshot" "db_snapshot" {
#   db_instance_identifier = "your-db-instance-name"  # Change to your DB instance identifier
#   db_snapshot_identifier = "snapshot-for-export-${formatdate("YYYY-MM-DD-hh-mm", timestamp())}"
# }

# # Export task from DB snapshot to S3
# resource "aws_db_snapshot_export_task" "export_task" {
#   export_task_identifier = "my-db-export-task"
#   source_arn             = aws_db_snapshot.db_snapshot.db_snapshot_arn
#   s3_bucket_name         = aws_s3_bucket.db_export_bucket.id
#   iam_role_arn           = aws_iam_role.rds_export_role.arn
#   kms_key_id             = "alias/aws/rds"  # Use default RDS KMS key

#   export_only = ["database"]  # Export only the database, not the logs
# }
