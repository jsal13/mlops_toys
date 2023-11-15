# Global Naming Pattern
# REF: https://stepan.wtf/cloud-naming-convention/

# [prefix]-[project]-[env]-[resource]-[location]-[desc]-[suffix]
# Component	Description	     Req.   Constraints
# prefix	  Fixed prefix	    ✔	    len 3, fixed
# project	  Project name	    ✔	    len 4-10, a-z0-9
# env 	    Environment	      ✔     len 1, a-z, enum
# resource	Resource type	    ✔	    len 3, a-z, enum
# location	Resource location	✗	    len 1-6, a-z0-9
# desc	    Additional desc 	✗	    len 1-20, a-z0-9
# suffix	  Random suffix	    ✗	    len 4, a-z0-9

variable "prefix" {
  type    = string
  default = "jsv"

  validation {
    condition     = length(var.prefix) == 3
    error_message = "prefix value must be length 3."
  }
}

variable "project" {
  type    = string
  default = "tmpl"

  validation {
    condition     = length(var.project) >= 4 && length(var.project) <= 10 && can(regex("^[0-9A-Za-z]+$", var.project))
    error_message = "project value must have length >= 4 and <= 10."
  }

  validation {
    condition     = can(regex("^[0-9A-Za-z]+$", var.project))
    error_message = "For the project value only a-z, A-Z and 0-9 are allowed."

  }
}

variable "env" {
  type    = string
  default = "d"

  validation {
    condition     = contains(["d", "s", "p"], var.env)
    error_message = "env must be 'd', 's', or 'p'."
  }
}

# Location and Zone Variables
variable "aws_region" {
  type        = string
  description = "AWS region to launch servers."
  default     = "us-east-1"
}


# Default VPC Vars
variable "azs" {
  type        = list(string)
  description = "Public Subnet AZ Infomration"
  default     = ["us-east-1a"]
}

variable "cidr" {
  type        = string
  description = "VPC CIDR."
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  type        = list(string)
  description = "VPC Public Subnets."
  default     = ["10.0.101.0/24"]
}

# variable "private_subnets" {
#   type    = string
#   description = "VPC Private Subnets."
#   default = ["10.0.1.0/24"]
# }
