variable "app_name" {
  type    = string
  default = "mlops_toys_iceberg_s3_lakehouse"
}

variable "date" {
  type        = string
  description = "YYYY-MM-DD format."
  default     = "2023-10-24"
}

#Location and Zone Variables
variable "aws_region" {
  type        = string
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "public_subnet_az" {
  type        = list(string)
  description = "Public Subnet AZ Infomration"
  default     = ["us-east-1a"]
}
