provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket  = "s3-bucket-josemanuel"
    key     = "github-actions-demo-josemanuel/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

resource "aws_s3_bucket" "web" {
  bucket = "mi-app-web-josemanuelcruz"
}

resource "aws_s3_bucket_website_configuration" "web_config" {
  bucket = aws_s3_bucket.web.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "web_public" {
  bucket = aws_s3_bucket.web.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.web.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:GetObject",
      Resource  = "${aws_s3_bucket.web.arn}/*"
    }]
  })
}

output "bucket_name" {
  value = aws_s3_bucket.web.bucket
}

output "website_url" {
  value = aws_s3_bucket_website_configuration.web_config.website_endpoint
}