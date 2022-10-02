# EKS Cluster Input Variables
variable "eks_node_instance_type" {
  description = "EKS instance type"
  type = string
  default = "t3.medium"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type = string
  default = "default-eks"
}

variable "cluster_service_ipv4_cidr" {
  description = "service IPv4 CIDR for the Kubernetes Cluster"
  type = string
  default = null
}

variable "cluster_version" {
  description = "Kubernetes minor version to use for the EKS cluster"
  type = string
  default = null
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  type = bool
  default = false
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoins is enabled. When it's set to `false` ensure to have proper private access with the `cluster_endpoint_private_access = true`"
  type = bool
  default = true
}

variable "cluster_endpoint_public_access_cidr" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  type = list(string)
  default = [ "0.0.0.0/0" ]
}