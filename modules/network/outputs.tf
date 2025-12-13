output "vpc_id" {
  description = "The ID of the main VPC."
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "A list of Private Subnet IDs. EC2/RDS should be deployed here."
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "public_subnet_ids" {
  description = "A list of Public Subnet IDs. Load Balancers should be deployed here."
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "database_subnet_group_name" {
  description = "The name of the DB Subnet Group, required for RDS."
  value       = aws_db_subnet_group.default.name
}

# Bonus: Create a DB Subnet Group, required by the RDS module
resource "aws_db_subnet_group" "default" {
  name       = "${var.service_name}-db-sng"
  subnet_ids = [for subnet in aws_subnet.private : subnet.id] # Use private subnets for the database
  
  tags = {
    Name = "${var.service_name}-db-sng"
  }
}