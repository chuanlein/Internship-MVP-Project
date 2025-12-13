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
  # NOTE: In a real deployment, you would likely use a data source to dynamically fetch AZs.
}

variable "service_name" {
  description = "The name of the service/project (for naming/tagging)."
  type        = string
}

variable "environment" {
  description = "The environment tag (e.g., dev, stage, prod)."
  type        = string
}