# VPC Variables
variable "vpc_name" {
  description = "VPC Name"
  type = string
  default = "default-vpc"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type = string
}

# variable "vpc_availability_zones" {
#   description = "VPC availability zones"
#   type = list(string)
# }

variable "vpc_public_subnets" {
  description = "VPC Public Subnets"
  type = list(string)
}

variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type = list(string)
}

variable "vpc_database_subnets" {
  description = "VPC Database Subnets"
  type = list(string)
}

# VPC Create Databsae Subnet Group (TRUE/FALSE)
variable "vpc_create_database_subnet_group" {
    description = "VPC Create Database Subnet Group"
    type = bool
}

# VPC Create Database Subnet Route Table (TRUE/FALSE)
variable "vpc_create_database_subnet_route_table" {
    description = "VPC Create Database Subnet Route Table"
    type = bool
}

# VPC Enable NAT Gateway (TRUE/FALSE)
variable "vpc_enable_nat_gateway" {
    description = "Enable NAT Gateways for Private Subnets Outbound Communication"
    type = bool
}

# VPC Single NAT Gateway
variable "vpc_single_nat_gateway" {
    description = "Enable only single NAT Gateway in one Availability Zone to save costs during our demos"
    type = bool
}



