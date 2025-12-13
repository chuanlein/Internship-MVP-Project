output "db_endpoint" {
  description = "The connection endpoint for the RDS instance."
  value       = aws_db_instance.app_db.address
}

output "db_sg_id" {
  description = "The Security Group ID for the database."
  value       = aws_security_group.db_sg.id
}