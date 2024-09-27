terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

# Warning: This costs money.
resource "aws_kms_key" "test" {
  description             = "Temporary KMS Key for MLOps Toys"
  deletion_window_in_days = 7
}

output "arn_for_kms_key" {
  value = aws_kms_key.test.arn
}
