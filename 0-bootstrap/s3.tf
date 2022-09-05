resource "aws_s3_bucket" "state_bucket" {
  bucket = var.name_of_s3_bucket

  # Prevents Terraform from destroying or replacing this object - a great safety mechanism
  lifecycle {
    prevent_destroy = true
  }


  tags = merge(var.generic_tags,
    {
      Name = "${var.project}-state-s3"
  })
}
# Tells AWS to keep a version history of the state file
resource "aws_s3_bucket_versioning" "versioning_state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
# Tells AWS to encrypt the S3 bucket at rest by default
resource "aws_s3_bucket_server_side_encryption_configuration" "state_s3" {
  bucket = aws_s3_bucket.state_bucket.id
  rule {
    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"
    }
  }
}