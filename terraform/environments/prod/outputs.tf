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

# Argo CD outputs
output "argocd_namespace" {
  description = "Namespace where Argo CD is deployed"
  value       = module.argocd.argocd_namespace
}

output "argocd_admin_username" {
  description = "Argo CD admin username"
  value       = module.argocd.argocd_admin_username
}

output "argocd_admin_password" {
  description = "Argo CD initial admin password (run 'terraform output -raw argocd_admin_password' to view)"
  value       = module.argocd.argocd_initial_admin_password
  sensitive   = true
}

output "argocd_server_instructions" {
  description = "How to access Argo CD server"
  value       = "Run: kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}