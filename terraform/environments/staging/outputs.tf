output "vpc_id" {
  description = "VPC ID for the teststaging environment"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs for the teststaging environment"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs for the teststaging environment"
  value       = module.vpc.private_subnet_ids
}

output "cluster_name" {
  description = "EKS cluster name for the teststaging environment"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint for the teststaging environment"
  value       = module.eks.cluster_endpoint
}

output "node_group_name" {
  description = "EKS node group name for the teststaging environment"
  value       = module.eks.node_group_name
}

output "repository_url" {
  description = "ECR repository URL for the teststaging environment"
  value       = module.ecr.repository_url
}

output "jenkins_role_name" {
  description = "Jenkins IAM role name for the teststaging environment"
  value       = module.iam.jenkins_role_name
}

output "jenkins_instance_profile_name" {
  description = "Jenkins instance profile name for the teststaging environment"
  value       = module.iam.jenkins_instance_profile_name
}

output "jenkins_instance_id" {
  description = "Jenkins EC2 instance ID for the teststaging environment"
  value       = module.jenkins.instance_id
}

output "jenkins_public_ip" {
  description = "Jenkins public IP for the teststaging environment"
  value       = module.jenkins.public_ip
}

output "jenkins_public_dns" {
  description = "Jenkins public DNS for the teststaging environment"
  value       = module.jenkins.public_dns
}