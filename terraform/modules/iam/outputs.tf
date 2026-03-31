output "jenkins_role_arn" {
  value = aws_iam_role.jenkins.arn
}

output "jenkins_instance_profile_name" {
  value = aws_iam_instance_profile.jenkins.name
}

output "jenkins_role_name" {
  value = aws_iam_role.jenkins.name
}