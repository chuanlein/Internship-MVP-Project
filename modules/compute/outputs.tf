output "instance_id" {
  description = "The ID of the created EC2 instance."
  value       = aws_instance.app_server.id
}

output "security_group_id" {
  description = "The ID of the Security Group created for the application server."
  value       = aws_security_group.app_sg.id
}

output "private_ip" {
  description = "The private IP address of the EC2 instance."
  value       = aws_instance.app_server.private_ip
}