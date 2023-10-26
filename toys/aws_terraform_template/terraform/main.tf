provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      app = local.app_name
    }
  }
}

locals {
  app_name = "${var.prefix}-${var.project}-${var.env}"
}

