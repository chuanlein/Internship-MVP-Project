# 1. IAM Role and Instance Profile (Security Best Practice: Least Privilege)
# This role grants the EC2 instance permissions to interact with other AWS services.

resource "aws_iam_role" "app_role" {
  name = "${var.service_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name        = "${var.service_name}-role"
    Environment = var.environment
  }
}

# modules/compute/main.tf (Conceptual True Least Privilege)

resource "aws_iam_role_policy" "s3_access_policy" {
  name = "${var.service_name}-s3-access"
  role = aws_iam_role.app_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Effect = "Allow",
        # CRITICAL: This restricts access to only the bucket ARN passed into the module.
        Resource = [
          "${var.s3_bucket_arn}",
          "${var.s3_bucket_arn}/*"
        ]
      },
    ]
  })
}

resource "aws_iam_instance_profile" "app_profile" {
  name = "${var.service_name}-ec2-profile"
  role = aws_iam_role.app_role.name
}


# 2. Security Group (Networking Best Practice: Explicit Rules)
# Controls inbound and outbound traffic for the EC2 instance.

resource "aws_security_group" "app_sg" {
  name        = "${var.service_name}-sg"
  description = "Allow inbound traffic for the microservice and SSH"
  vpc_id      = var.vpc_id
    
## CRITICAL FIX: Restrict Ingress. This should NOT be 0.0.0.0/0
  ingress {
    description = "Allow App traffic (Port 8080) from Load Balancer/Public Layer"
    from_port   = var.service_port
    to_port     = var.service_port
    protocol    = "tcp"
    # Assuming you pass the Security Group ID of the Load Balancer
    security_groups = [var.lb_security_group_id]
  }
  
  # Allow all outbound traffic (default for most apps)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.service_name}-sg"
    Environment = var.environment
  }
}


# 3. EC2 Instance (Compute)
# The application server itself.

resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.app_profile.name
  
  # Conceptual Monitoring/Logging: User data to install an agent
  # This section simulates the installation of a CloudWatch agent or startup script.
  user_data = <<-EOF
              #!/bin/bash
              echo "Installing application and monitoring agent..." >> /tmp/startup.log
              # Conceptual: Install CloudWatch agent here
              # Conceptual: Start microservice application here
              EOF

  tags = {
    Name        = "${var.service_name}-server"
    Environment = var.environment
    Service     = var.service_name
  }
}