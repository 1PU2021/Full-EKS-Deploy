output "vpc_id" {
  description = "VPC ID for the dev environment"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs for the dev environment"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs for the dev environment"
  value       = module.vpc.private_subnet_ids
}

output "cluster_name" {
  description = "EKS cluster name for the dev environment"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint for the dev environment"
  value       = module.eks.cluster_endpoint
}

output "node_group_name" {
  description = "EKS node group name for the dev environment"
  value       = module.eks.node_group_name
}

output "repository_url" {
  description = "ECR repository URL for the dev environment"
  value       = module.ecr.repository_url
}