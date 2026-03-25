output "state_bucket_name" {
  description = "Terraform remote state bucket name"
  value       = aws_s3_bucket.terraform_state.id
}