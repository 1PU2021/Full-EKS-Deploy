terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }

  backend "s3" {
    bucket  = "realworldsim-tc2-terraform-state-9420-us-east-2"
    key     = "tc2/prod/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
}

# Kubernetes provider configuration
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_data)
  
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks.cluster_name,
      "--region",
      var.aws_region
    ]
  }
}

# Helm provider - references kubernetes provider configuration
provider "helm" {
}

module "vpc" {
  source = "../../modules/vpc"

  environment_name     = var.environment_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "eks" {
  source = "../../modules/eks"

  environment_name   = var.environment_name
  cluster_name       = var.cluster_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  eks_cluster_sg_id  = module.vpc.eks_cluster_sg_id
  jenkins_role_arn = module.iam.github_actions_role_arn
  enable_cluster_admin_principal = true
  node_instance_name = "${var.environment_name}-eks-node"

  node_desired_size = var.node_desired_size
  node_min_size     = var.node_min_size
  node_max_size     = var.node_max_size
  
}

module "ecr" {
  source = "../../modules/ecr"

  environment_name = var.environment_name
  repository_name  = var.repository_name
}

# Argo CD for GitOps continuous delivery
module "argocd" {
  source = "../../modules/argocd"

  environment_name = var.environment_name
  cluster_name     = var.cluster_name
  git_repo_url     = var.git_repo_url
  git_branch       = var.git_branch

  depends_on = [module.eks]
}
module "iam" {
  source = "../../modules/iam"

  environment_name   = var.environment_name
  eks_cluster_name   = var.cluster_name

  enable_jenkins     = var.enable_jenkins
  enable_github_oidc = true

  github_org   = "1PU2021"
  github_repo  = "Full-EKS-Deploy"
  github_branch = "prod"
  github_environment = "prod"
}

module "jenkins" {
  source = "../../modules/jenkins"

  enable_jenkins       = var.enable_jenkins
  environment_name     = var.environment_name
  ami_id               = var.jenkins_ami_id
  instance_type        = var.jenkins_instance_type
  subnet_id            = module.vpc.public_subnet_ids[0]
  security_group_id    = module.vpc.jenkins_sg_id
  instance_profile_name = module.iam.jenkins_instance_profile_name
  key_name             = var.jenkins_key_name
  root_volume_size     = var.jenkins_root_volume_size
}