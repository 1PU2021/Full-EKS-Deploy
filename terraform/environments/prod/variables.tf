variable "aws_region" {
  description = "AWS region for this environment"
  type        = string
}

variable "environment_name" {
  description = "Environment name"
  type        = string
}

variable "node_desired_size" {
  description = "Desired node count for the EKS node group"
  type        = number
}

variable "node_min_size" {
  description = "Minimum node count for the EKS node group"
  type        = number
}

variable "node_max_size" {
  description = "Maximum node count for the EKS node group"
  type        = number
}

variable "enable_jenkins" {
  description = "Whether to create Jenkins for this environment"
  type        = bool
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for the subnets"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "git_repo_url" {
  description = "Git repository URL for Argo CD to sync from"
  type        = string
}

variable "git_branch" {
  description = "Git branch for Argo CD to sync from"
  type        = string
  default     = "Prod"
}

variable "jenkins_ami_id" {
  description = "AMI ID for Jenkins EC2"
  type        = string
}

variable "jenkins_instance_type" {
  description = "Instance type for Jenkins EC2"
  type        = string
}

variable "jenkins_key_name" {
  description = "Key pair name for Jenkins EC2"
  type        = string
}

variable "jenkins_root_volume_size" {
  description = "Root volume size for Jenkins EC2"
  type        = number
}