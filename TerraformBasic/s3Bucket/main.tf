resource "aws_s3_bucket" "ap-s3" {
  bucket = var.webBucket

  tags = {
    Name = "AWS-Static-Website Bucket"
    description = "for static website"
  }
}

resource "aws_s3_bucket" "prviateS3" {
    bucket = var.privateBucket

    tags = {
      Name = "private-s3"
      description = "private s3"
    }
  
}
output "aws-url" {
  value = aws_s3_bucket_website_configuration.aws-website.website_endpoint
}
