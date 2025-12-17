# --- Terraform and Provider Configuration ---

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


# 1. Call the Network module (Foundation)
module "network" {
  source       = "../../modules/network" # <-- FIX: Go up two levels to find the modules folder
  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
  environment  = var.environment
  azs          = var.azs
}

# 2. Call the Compute (Microservice) module (Application Layer)
module "microservice_app" {
  source       = "../../modules/compute" # <-- FIX: Go up two levels to find the modules folder
  service_name = var.project_name
  environment  = var.environment
  ami_id       = var.ami_id

# CRITICAL FIX: Add the required argument for the LB Security Group ID
  lb_security_group_id = "" # <-- Pass an empty string placeholder for now Group ID

  # Connect inputs required by modules/compute/variables.tf:
  vpc_cidr      = var.vpc_cidr
  vpc_id        = module.network.vpc_id
  subnet_id     = module.network.private_subnet_ids[0]
  s3_bucket_arn = module.storage.bucket_arn # Dependency on Storage module

  instance_type = "t3.micro"
  service_port  = 8080
}

# 3. Call the Database (RDS) module (Data Persistetence Layer)
module "database" {
  source       = "../../modules/database" # <-- FIX: Go up two levels to find the modules folder
  service_name = var.project_name
  environment  = var.environment

  # Input values from the NETWORK module:
  vpc_id = module.network.vpc_id

  # Pass the subnet group name using the variable expected by the database module.
  db_subnet_group_name = module.network.database_subnet_group_name

  # Input value from the COMPUTE module:
  # Pass the compute layer security group ID using the variable expected by the database module.
  compute_sg_id = module.microservice_app.security_group_id

  # Input values from root variables:
  db_username       = var.db_username
  db_password       = var.db_password
  db_instance_class = "db.t3.micro"
}

# 4. Call the Storage module (Static Asset/File Layer)
module "storage" {
  source       = "../../modules/storage" # <-- FIX: Go up two levels to find the modules folder
  service_name = var.project_name
  environment  = var.environment
}