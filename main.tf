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
  source       = "./modules/network"
  service_name = var.project_name
  environment  = var.environment
  azs          = var.azs
}

# 2. Call the Compute (Microservice) module (Application Layer)
module "microservice_app" {
  source       = "./modules/compute"
  service_name = var.project_name
  environment  = var.environment
  ami_id       = var.ami_id

  # Connect Network Output to Compute Input:
  vpc_id    = module.network.vpc_id
  subnet_id = module.network.private_subnet_ids[0] # Deploy to the first private subnet

  # Pass S3 ARN for Least Privilege Policy
  s3_bucket_arn = module.storage.bucket_arn
  instance_type = "t3.micro"
  service_port  = 8080
}

# 3. Call the Database (RDS) module (Data Persistence Layer)
module "database" {
  source       = "./modules/database"
  service_name = var.project_name
  environment  = var.environment

  # Input values from the NETWORK module:
  vpc_id               = module.network.vpc_id
  db_subnet_group_name = module.network.database_subnet_group_name

  # Input value from the COMPUTE module (Security Group dependency):
  compute_sg_id = module.microservice_app.security_group_id

  # Input values from root variables:
  db_username       = var.db_username
  db_password       = var.db_password
  db_instance_class = "db.t3.micro"
}

# 4. Call the Storage module (Static Asset/File Layer)
module "storage" {
  source       = "./modules/storage"
  service_name = var.project_name
  environment  = var.environment
}