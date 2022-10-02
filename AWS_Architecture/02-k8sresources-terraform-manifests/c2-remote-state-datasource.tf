# Terraform Remote State DataSource
data "terraform_remote_state" "eks" {
  # backend = "local"
  # config = {
  #   path = "../../03-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests/terraform.tfstate"
  #  }
  backend = "s3" 
  config = {
    bucket = "s3-tfs-gb-st-01"
    key = "automation/dev/finance/eks/cluster/flaskapp_aws-terraform.tfstate"
    region = "ap-southeast-1"
  }
}