variable "vpc_id" {
  description = "The VPC ID where the EC2 instance will be deployed."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the Subnet where the EC2 instance will reside (ideally a private subnet)."
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to use (e.g., t3.micro)."
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "The ID of the Amazon Machine Image (AMI) to use."
  type        = string
  # NOTE: In a real scenario, you'd use a data source to fetch the latest AMI.
  # For this conceptual model, you can use a placeholder or find a valid one.
}

variable "service_port" {
  description = "The port the microservice listens on (e.g., 8080)."
  type        = number
  default     = 8080
}

variable "service_name" {
  description = "The name of the service/microservice (for naming/tagging)."
  type        = string
}

variable "environment" {
  description = "The environment tag (e.g., dev, stage, prod)."
  type        = string
}

variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket the microservice needs to access."
  type        = string
}