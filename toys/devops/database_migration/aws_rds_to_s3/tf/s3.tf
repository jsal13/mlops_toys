# S3 bucket to store the database dumps
resource "aws_s3_bucket" "db_export_bucket" {
  bucket = "james-salvatore-test-2025-02-26"
}

# S3 bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "db_export_bucket_ownership" {
  bucket = aws_s3_bucket.db_export_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# S3 bucket ACL
resource "aws_s3_bucket_acl" "db_export_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.db_export_bucket_ownership]
  bucket     = aws_s3_bucket.db_export_bucket.id
  acl        = "private"
}

# S3 bucket server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "db_export_bucket_encryption" {
  bucket = aws_s3_bucket.db_export_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# IAM role for RDS to export to S3
resource "aws_iam_role" "rds_export_role" {
  name = "rds-export-to-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "export.rds.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for S3 access
resource "aws_iam_policy" "rds_export_policy" {
  name        = "rds-export-to-s3-policy"
  description = "Policy to allow RDS to export snapshots to S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject*",
          "s3:ListBucket",
          "s3:GetObject*",
          "s3:DeleteObject*",
          "s3:GetBucketLocation"
        ]
        Resource = [
          aws_s3_bucket.db_export_bucket.arn,
          "${aws_s3_bucket.db_export_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "rds_export_attachment" {
  role       = aws_iam_role.rds_export_role.name
  policy_arn = aws_iam_policy.rds_export_policy.arn
}
