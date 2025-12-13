# 1. S3 Bucket (The Static Storage)
# We use a standard bucket and enforce security best practices.

resource "aws_s3_bucket" "static_assets" {
  # Use a combination of service name and environment for a globally unique bucket name.
  # Note: S3 bucket names must be globally unique and conform to DNS naming rules.
  bucket = "${var.service_name}-${var.environment}-assets"

  tags = {
    Name        = "${var.service_name}-assets"
    Environment = var.environment
  }
}
# 2. S3 Bucket Server-Side Encryption (Security Best Practice: Data at Rest)
# Enforce encryption for all objects stored in the bucket.

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.static_assets.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # Simple S3 managed encryption
    }
  }
}
# 3. S3 Bucket Public Access Block (Security Best Practice: Prevent Public Access)
# This resource explicitly blocks all public access to the bucket, 
# ensuring assets are accessed only via authorized IAM roles (like the one attached to EC2).

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.static_assets.id

  # Enforce block settings
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 4. S3 Bucket Versioning (Resilience Best Practice)
# Enables versioning to protect against accidental deletion or overwrites.

resource "aws_s3_bucket_versioning" "versioning_enabled" {
  bucket = aws_s3_bucket.static_assets.id
  versioning_configuration {
    status = "Enabled"
  }
}


