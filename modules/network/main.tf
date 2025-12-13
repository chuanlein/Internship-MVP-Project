# 1. VPC (Virtual Private Cloud)
# The isolated virtual network container.

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.service_name}-vpc"
    Environment = var.environment
  }
}

# 2. Internet Gateway (IGW)
# Allows communication between the VPC and the internet (via public subnets).

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.service_name}-igw"
  }
}

# 3. Public Subnets
# For resources that need direct internet access (like Load Balancers or Bastion Hosts).
# We use 'count' to create subnets across multiple Availability Zones (AZs) for high availability.

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index] # Distribute across AZs
  map_public_ip_on_launch = true                 # Allows public IPs for public subnets

  tags = {
    Name        = "${var.service_name}-public-subnet-${count.index + 1}"
    Tier        = "Public"
    Environment = var.environment
  }
}

# 4. Private Subnets
# For secure resources (like EC2 microservices and RDS databases).
# They can only access the internet via a NAT Gateway.

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name        = "${var.service_name}-private-subnet-${count.index + 1}"
    Tier        = "Private"
    Environment = var.environment
  }
}

# 5. Public Route Table
# Route table for the public subnets, pointing internet-bound traffic (0.0.0.0/0) to the IGW.

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.service_name}-public-rt"
  }
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# 6. NAT Gateway (Crucial for private instances to get updates/patches)
# An elastic IP is required for the NAT Gateway.

resource "aws_eip" "nat" {
  count      = length(aws_subnet.public) # One NAT Gateway per public subnet/AZ
  
  # The tags are crucial for organization
  tags = {
    Name = "${var.service_name}-nat-eip-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = length(aws_subnet.public)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id # NAT GW must reside in a public subnet

  tags = {
    Name = "${var.service_name}-nat-gw-${count.index + 1}"
  }
}