variable "service_name" {
  description = "The name of the service/project (for naming/tagging)."
  type        = string
}

variable "environment" {
  description = "The environment tag (e.g., dev, stage, prod)."
  type        = string
}