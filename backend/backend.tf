resource "random_string" "tfstate" {
    length = 6
    special = false
    numeric = false
    upper   = false
}
locals {
  name = "${var.profile}-${var.environment}"
}
resource "aws_s3_bucket" "tfstate" {
    bucket = "${local.name}-tfstate-${random_string.tfstate.result}-${var.region}"
}
resource "aws_s3_bucket_acl" "tfstate" {
    bucket = aws_s3_bucket.tfstate.id
    acl = "private"
    depends_on = [aws_s3_bucket_ownership_controls.tfstate]
}
resource "aws_s3_bucket_ownership_controls" "tfstate" {
    bucket = aws_s3_bucket.tfstate.id
    rule {
      object_ownership = "ObjectWriter"
    }
  
}

resource "aws_s3_bucket_versioning" "tfstate" {
    bucket = aws_s3_bucket.tfstate.id
    versioning_configuration {
      status = "Enabled"
    }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
    bucket = aws_s3_bucket.tfstate.id
    rule {
      bucket_key_enabled = true

      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    } 
}
resource "aws_s3_bucket_public_access_block" "tfstate" {
    bucket = aws_s3_bucket.tfstate.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}
resource "aws_dynamodb_table" "tfstate" {
  name         = "${local.name}-tfstate"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
resource "local_file" "config" {
  filename        = "../config/backend-${var.environment}.tfvars"
  content         = <<EOT
region = "${var.region}"
bucket = "${aws_s3_bucket.tfstate.id}"
key = "terraform.tfstate"
dynamodb_table = "${aws_dynamodb_table.tfstate.name}"
  EOT
  file_permission = "0644"
}