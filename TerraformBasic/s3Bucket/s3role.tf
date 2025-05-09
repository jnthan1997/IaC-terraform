#Set Ownership for uploaded Object in Bucket

resource "aws_s3_bucket_ownership_controls" "pubOwnership" {
    bucket = aws_s3_bucket.ap-s3.id
    
    rule {
      object_ownership = "BucketOwnerPreferred"
    }
}

#Set Public Bucket access
resource "aws_s3_bucket_public_access_block" "pubBlock" {
    bucket = aws_s3_bucket.ap-s3.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
  
}
  
#Set Public Bucket Access Control List
resource "aws_s3_bucket_acl" "pubACL" {
    depends_on = [ aws_s3_bucket_public_access_block.pubBlock,
                    aws_s3_bucket_ownership_controls.pubOwnership
                 ]
    bucket = aws_s3_bucket.ap-s3.id
    acl = "public-read"
  
}


## Enable Versioning for public Bucket
resource "aws_s3_bucket_versioning" "version" {
    bucket = aws_s3_bucket.ap-s3.id

    versioning_configuration {
        status = "Enabled"
    }
  
}


## Enable Versioning for Private Bucket
resource "aws_s3_bucket_versioning" "bucketVersion" {
    bucket = aws_s3_bucket.prviateS3.id

    versioning_configuration {
        status = "Enabled"
    }
  
}


#Set Object Life expirate inside s3 with video tag
resource "aws_s3_bucket_lifecycle_configuration" "publicLife" {

    bucket = aws_s3_bucket.ap-s3.id
    rule {
      id = "Object Expiration"
      status = "Enabled"
      filter {
        prefix = "video/"
      }
      expiration {
        days = 1
      }
    }
}


#Transfer object in private s3 to standard bucket after days*
resource "aws_s3_bucket_lifecycle_configuration" "privateLife" {

    bucket = aws_s3_bucket.prviateS3.id
    rule {
      id = "Object Transition"
      status = "Enabled"
      filter {
        prefix = "video/"
      }
      transition {
        days = 30
        storage_class = "STANDARD_IA"
      }
    }
}

#Enable Web configuration in s3 bucket
resource "aws_s3_bucket_website_configuration" "aws-website" {
    bucket = aws_s3_bucket.ap-s3.id
    index_document {
        suffix = "index.html"
    }
    error_document {

      key = "404.JPG"

    }
  
}

#upload object in public s3
resource "aws_s3_object" "indexhtml" {
  bucket = aws_s3_bucket.ap-s3.id
  key = "index.html"
  source = "./simplewebsite/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "css" {
  bucket = aws_s3_bucket.ap-s3.id
  key = "styles.css"
  source = "./simplewebsite/styles.css"
  content_type = "text/css"
}


resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.ap-s3.id
  key = "404.JPG"
  source = "./simplewebsite/404.JPG"
  content_type = "image/JPG"
}

resource "aws_s3_bucket_policy" "bucketpolicy" {

    bucket = aws_s3_bucket.ap-s3.id
    policy = data.aws_iam_policy_document.webpolicy.json
  
}

data "aws_iam_policy_document" "webpolicy" {
      statement {
    sid    = "AllowPublicRead"
    effect = "Allow"
resources = [
      "${aws_s3_bucket.ap-s3.arn}",
      "${aws_s3_bucket.ap-s3.arn}/*",
    ]
actions = ["S3:GetObject"]
principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
depends_on = [ aws_s3_bucket_public_access_block.pubBlock ]
  
}