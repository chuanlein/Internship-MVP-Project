output "vpc_id" {
  description = "The ID of the main VPC."
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "A list of Private Subnet IDs. EC2/RDS should be deployed here."
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "A list of Public Subnet IDs. Load Balancers should be deployed here."
  value       = aws_subnet.public[*].id
}

output "database_subnet_group_name" {
  description = "The name of the DB Subnet Group, required for RDS."
  value       = aws_db_subnet_group.db_group.name 
}