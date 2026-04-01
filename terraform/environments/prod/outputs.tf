output "vpc_id" {
  description = "VPC ID for the prod environment"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs for the prod environment"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs for the prod environment"
  value       = module.vpc.private_subnet_ids
}

output "cluster_name" {
  description = "EKS cluster name for the prod environment"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint for the prod environment"
  value       = module.eks.cluster_endpoint
}

output "node_group_name" {
  description = "EKS node group name for the prod environment"
  value       = module.eks.node_group_name
}

output "repository_url" {
  description = "ECR repository URL for the prod environment"
  value       = module.ecr.repository_url
}

output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions IAM role"
  value       = module.iam.github_actions_role_arn
}

output "github_oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = module.iam.github_oidc_provider_arn
}

output "jenkins_role_arn" {
  description = "ARN of the Jenkins IAM role"
  value       = module.iam.jenkins_role_arn
}

output "jenkins_instance_profile_name" {
  description = "Name of the Jenkins instance profile"
  value       = module.iam.jenkins_instance_profile_name
}

output "eks_update_kubeconfig_command" {
  description = "Command to update local kubeconfig for the prod cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}