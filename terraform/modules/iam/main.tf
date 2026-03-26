data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "jenkins_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "jenkins" {
  name               = "${var.environment_name}-jenkins-role"
  assume_role_policy = data.aws_iam_policy_document.jenkins_assume_role.json

  tags = {
    Name = "${var.environment_name}-jenkins-role"
  }
}

resource "aws_iam_instance_profile" "jenkins" {
  name = "${var.environment_name}-jenkins-instance-profile"
  role = aws_iam_role.jenkins.name
}

resource "aws_iam_role_policy_attachment" "ecr_power_user" {
  role       = aws_iam_role.jenkins.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

data "aws_iam_policy_document" "jenkins_eks_describe_cluster" {
  count = var.eks_cluster_name != "" ? 1 : 0

  statement {
    sid    = "AllowDescribeSpecificEKSCluster"
    effect = "Allow"

    actions = [
      "eks:DescribeCluster"
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${var.eks_cluster_name}"
    ]
  }
}

resource "aws_iam_role_policy" "jenkins_eks_describe_cluster" {
  count = var.eks_cluster_name != "" ? 1 : 0

  name   = "${var.environment_name}-jenkins-eks-describe-cluster"
  role   = aws_iam_role.jenkins.id
  policy = data.aws_iam_policy_document.jenkins_eks_describe_cluster[0].json
}