# DataSource IAM
data "aws_iam_policy" "aws_eks_cluster_policy" {
  name = "AmazonEKSClusterPolicy"
}

data "aws_iam_policy" "aws_eks_vpc_resource_controller" {
  name = "AmazonEKSVPCResourceController"
}

# Create IAM Role
resource "aws_iam_role" "eks_cluster_role" {
  name = "${local.name}-eks-cluster-role"

  assume_role_policy = <<POLICY
  {
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": {
			    "Service": "eks.amazonaws.com"
			},
			"Action": "sts:AssumeRole"
		}
	]
}
  POLICY
}

# Associate IAM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  policy_arn = data.aws_iam_policy.aws_eks_cluster_policy.arn
  role = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSVPCResourceController" {
  policy_arn = data.aws_iam_policy.aws_eks_vpc_resource_controller.arn
  role = aws_iam_role.eks_cluster_role.name
}