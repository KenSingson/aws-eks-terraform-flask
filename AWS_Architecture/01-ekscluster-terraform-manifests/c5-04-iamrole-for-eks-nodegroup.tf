# IAM Role for EKS NodeGroup
# DataSource IAM
data "aws_iam_policy" "aws_eks_worker_node_policy" {
  name = "AmazonEKSWorkerNodePolicy"
}

data "aws_iam_policy" "aws_eks_cni_policy" {
  name = "AmazonEKS_CNI_Policy"
}

data "aws_iam_policy" "aws_ec2_container_registry_read_only" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}

# Create IAM Role
resource "aws_iam_role" "eks_nodegroup_role" {
  name = "${local.name}-eks-nodegroup-role"

  assume_role_policy = jsonencode({
    Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "ec2.amazonaws.com"
        }
    }]
    Version = "2012-10-17"
  })
}

# Associate IAM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
  policy_arn = data.aws_iam_policy.aws_eks_worker_node_policy.arn
  role = aws_iam_role.eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
  policy_arn = data.aws_iam_policy.aws_eks_cni_policy.arn
  role = aws_iam_role.eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = data.aws_iam_policy.aws_ec2_container_registry_read_only.arn
  role = aws_iam_role.eks_nodegroup_role.name
}
