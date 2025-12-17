variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "A list of CIDR blocks for the private subnets."
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "azs" {
  description = "A list of Availability Zones to use (e.g., [\"us-east-1a\", \"us-east-1b\"])."
  type        = list(string)
}

# This is the NEW variable that REPLACES service_name and environment
variable "project_name" { 
  description = "The name of the project/service (used for naming, tagging, and the DB Subnet Group)."
  type        = string
}

variable "environment" {
  description = "The environment tag (e.g., dev, stage, prod) used for resource tagging."
  type        = string
}