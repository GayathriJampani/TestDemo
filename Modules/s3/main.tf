resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-wordpress-012" # globally unique bucket name

  tags = {
    Name        = "terraform-state-wordpress"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}