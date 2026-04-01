terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

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

data "tls_certificate" "github_actions" {
  count = var.enable_github_oidc ? 1 : 0
  url   = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  count = var.enable_github_oidc ? 1 : 0

  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github_actions[0].certificates[0].sha1_fingerprint]
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  count = var.enable_github_oidc ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions[0].arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/${var.github_branch}",
        "repo:${var.github_org}/${var.github_repo}:environment:${var.github_environment}"
      ]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  count = var.enable_github_oidc ? 1 : 0

  name               = "${var.environment_name}-github-actions-role"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role[0].json

  tags = {
    Name = "${var.environment_name}-github-actions-role"
  }
}

resource "aws_iam_role_policy_attachment" "github_actions_ecr_power_user" {
  count = var.enable_github_oidc ? 1 : 0

  role       = aws_iam_role.github_actions[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}