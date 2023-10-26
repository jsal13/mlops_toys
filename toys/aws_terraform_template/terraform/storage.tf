# module "s3_bucket_data" {
#   source  = "terraform-aws-modules/s3-bucket/aws"
#   version = "3.15.1"

#   bucket        = "${local.app_name}-bkt-description"
#   acl           = "private"
#   force_destroy = true

#   control_object_ownership = true
#   object_ownership         = "ObjectWriter"

#   versioning = {
#     enabled = false
#   }
# }

# // SAMPLE DATA.  You must generate this first.

# resource "aws_s3_object" "object" {
#   count  = 1
#   bucket = module.s3_bucket_data.s3_bucket_id
#   key    = "/data/data_0${count.index}.parquet"
#   source = "../sample_data/data_0${count.index}.parquet"
#   etag   = filemd5("../sample_data/data_0${count.index}.parquet")
# }
