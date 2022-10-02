# AWS REGION
variable "aws_region" {
    description = "Region in which AWS Resources to be created"
    type = string
    default = "ap-southeast-1"
}

variable "environment" {
  description = "Environment variable used as a prefix"
  type = string
  default = "dev"
}

variable "business_division" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type = string
  default = "finance"
}