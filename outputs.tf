# --- Key Infrastructure Outputs ---

output "vpc_id" {
  description = "The ID of the main VPC."
  value       = module.network.vpc_id
}

output "microservice_private_ip" {
  description = "The private IP address of the EC2 microservice instance."
  value       = module.microservice_app.private_ip
}

output "rds_db_endpoint" {
  description = "The connection endpoint for the RDS database."
  value       = module.database.db_endpoint
}

output "s3_assets_bucket_name" {
  description = "The name of the S3 bucket for static assets."
  value       = module.storage.bucket_id
}

output "note" {
  description = "Reminder about security."
  value       = "The EC2 instance is deployed in a private subnet. Use a bastion host or AWS Session Manager for access."
}