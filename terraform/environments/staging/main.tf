terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "realworldsim-tc2-terraform-state-9420-us-east-2"
    key     = "tc2/teststaging/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
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

  node_desired_size = var.node_desired_size
  node_min_size     = var.node_min_size
  node_max_size     = var.node_max_size
  jenkins_role_arn  = module.iam.jenkins_role_arn
}

module "ecr" {
  source = "../../modules/ecr"

  environment_name = var.environment_name
  repository_name  = var.repository_name
}

module "iam" {
  source = "../../modules/iam"

  environment_name = var.environment_name
  eks_cluster_name = var.cluster_name
}

module "jenkins" {
  source = "../../modules/jenkins"

  environment_name      = var.environment_name
  ami_id                = var.jenkins_ami_id
  instance_type         = var.jenkins_instance_type
  subnet_id             = module.vpc.public_subnet_ids[0]
  security_group_id     = module.vpc.jenkins_sg_id
  instance_profile_name = module.iam.jenkins_instance_profile_name
  key_name              = var.jenkins_key_name
  root_volume_size      = var.jenkins_root_volume_size
}