variable "environment_name" {
  description = "Environment name used for resource naming"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the cluster will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the EKS cluster and node groups"
  type        = list(string)
}

variable "eks_cluster_sg_id" {
  description = "Security group ID for the EKS cluster"
  type        = string
}

variable "node_desired_size" {
  description = "Desired size of the EKS node group"
  type        = number
}

variable "node_min_size" {
  description = "Minimum size of the EKS node group"
  type        = number
}

variable "node_max_size" {
  description = "Maximum size of the EKS node group"
  type        = number
}

variable "node_instance_types" {
  description = "Instance types for the EKS node group"
  type        = list(string)
  default     = ["t3.small"]
}

variable "jenkins_role_arn" {
  description = "ARN of the Jenkins IAM role to authorize for cluster access"
  type        = string
  default     = null
}