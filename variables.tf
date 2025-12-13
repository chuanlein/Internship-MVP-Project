# --- Provider Configuration ---

variable "aws_region" {
  description = "The AWS region to deploy the infrastructure into."
  type        = string
  default     = "us-east-1"
}

# --- Network Variables ---

variable "azs" {
  description = "A list of Availability Zones to use (min 2 for Multi-AZ deployments)."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instances."
  type        = string
  default     = "ami-0a3c3a9d2889218d3" # Placeholder for Amazon Linux 2
}

variable "project_name" {
  description = "The common prefix for all resources."
  type        = string
  default     = "mvp-bootcamp-project"
}

variable "environment" {
  description = "The environment tag (e.g., dev, stage, prod)."
  type        = string
  default     = "dev"
}
# --- Database Variables ---

variable "db_username" {
  description = "The master username for the RDS database."
  type        = string
  # SECURITY WARNING: Using a default here is for conceptual modeling only. 
  default = "dbadmin"
}

variable "db_password" {
  description = "The master password for the RDS database."
  type        = string
  # SECURITY WARNING: Using a default here is for conceptual modeling only. 
  # In production, use a secure vault like AWS Secrets Manager.
  default   = "SecureP@ssw0rd123"
  sensitive = true # Mark as sensitive to prevent output in logs/state
}