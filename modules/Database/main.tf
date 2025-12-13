# 1. Database Security Group (Security Best Practice: Restrict Access)
# Only allow connections from the EC2 microservice Security Group (compute layer).

resource "aws_security_group" "db_sg" {
  name        = "${var.service_name}-db-sg"
  description = "Allow inbound traffic from app layer (EC2 SG) to DB."
  vpc_id      = var.vpc_id

  # Allow inbound traffic from the EC2 Security Group ONLY
  ingress {
    description     = "Allow DB traffic from Compute Layer"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [var.compute_sg_id] # Critical: Only the EC2 SG can connect
  }

  # Allow all outbound traffic (database needs to talk to AWS services for backups, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.service_name}-db-sg"
    Environment = var.environment
  }
}

# 2. RDS Instance (The Database)
# We model a PostgreSQL instance for the MVP.

resource "aws_db_instance" "app_db" {
  # Configuration
  engine               = "postgres"
  engine_version       = "15.6"
  instance_class       = var.db_instance_class
  allocated_storage    = 20 # Minimum storage
  max_allocated_storage = 100 # Enable storage autoscaling (best practice)
  
  # Credentials and Names
  db_name                 = var.db_name
  username             = var.db_username
  password             = var.db_password
  port                 = var.db_port
  
  # Networking and Security
  db_subnet_group_name = var.db_subnet_group_name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false # CRITICAL: Keep DB private

  # Operational Settings (Conceptual Monitoring/Resilience)
  skip_final_snapshot  = true # Set to false in production
  identifier           = "${var.service_name}-rds"
  multi_az             = true # Best practice for production resilience
  
  # Conceptual Logging: Enable CloudWatch Logs export
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  tags = {
    Name        = "${var.service_name}-rds"
    Environment = var.environment
  }
}