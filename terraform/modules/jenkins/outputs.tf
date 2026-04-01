output "instance_id" {
  value = var.enable_jenkins ? aws_instance.this[0].id : null
}

output "public_ip" {
  value = var.enable_jenkins ? aws_instance.this[0].public_ip : null
}

output "public_dns" {
  value = var.enable_jenkins ? aws_instance.this[0].public_dns : null
}