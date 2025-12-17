# modules/database/variables.tf (FINAL CORRECT VERSION - USING SHORT NAMES)

variable "db_name" {
  description = "Name of the database (e.g., 'appdb')."
  type        = string
  default     = "mvpdb"
}

variable "db_username" {
  description = "The master username for the database."
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "The master password for the database."
  type        = string
  default     = "SecureP@ssw0rd123" 
}

# --- CRITICAL FIX 1: Must use the SHORT name (db_subnet_group_name) ---
variable "db_subnet_group_name" { 
  description = "The name of the DB Subnet Group created in the network module."
  type        = string
}

variable "db_instance_class" {
  description = "The RDS instance type (e.g., db.t3.micro)."
  type        = string
  default     = "db.t3.micro"
}

variable "vpc_id" {
  description = "The VPC ID where the security group will be created."
  type        = string
}

variable "db_port" {
  description = "The port the database runs on (e.g., 5432 for Postgres)."
  type        = number
  default     = 5432 
}

variable "service_name" {
  description = "The name of the service/project (for naming/tagging)."
  type        = string
}

variable "environment" {
  description = "The environment tag (e.g., dev, stage, prod)."
  type        = string
}

# --- CRITICAL FIX 2: Must use the SHORT name (compute_sg_id) ---
variable "compute_sg_id" { 
  description = "The Security Group ID of the compute layer (EC2 microservice)."
  type        = string
}