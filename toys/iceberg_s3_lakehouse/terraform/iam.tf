data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    sid     = ""
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "glue.amazonaws.com",
        "lambda.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy" "AWSGlueServiceRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role" "glue_crawler_role" {
  name               = "glue_crawler_role"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "AWSGlueServiceRole-attach" {
  role       = aws_iam_role.glue_crawler_role.name
  policy_arn = data.aws_iam_policy.AWSGlueServiceRole.arn
}

// S3 Get-Put Objects.
data "aws_iam_policy_document" "s3_get_put_objects" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
      "s3:CreateBucket",
      "s3:PutObject"
    ]

    resources = [
      "${module.s3_bucket_data.s3_bucket_arn}",
      "${module.s3_bucket_data.s3_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_get_put_objects" {
  name   = "s3_get_put_objects"
  policy = data.aws_iam_policy_document.s3_get_put_objects.json
}

// GLUE PERMISSIONS
data "aws_iam_policy_document" "glue_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "glue:GetDatabase",
      "glue:GetDatabases",
      "glue:CreateDatabase",
      "glue:GetTables",
      "glue:GetTable",
      "glue:GetPartitions",
      "glue:CreateTable"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "glue_permissions" {
  name   = "glue_permissions"
  policy = data.aws_iam_policy_document.glue_permissions.json
}

// Attach Crawler Role.
resource "aws_iam_role_policy_attachment" "s3_get_put_objects-attach" {
  role       = aws_iam_role.glue_crawler_role.name
  policy_arn = aws_iam_policy.s3_get_put_objects.arn
}
