resource "aws_s3_bucket" "bucket" {
  bucket = var.bucketname
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_object" "index" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "index.html"
  source       = "html/index.html"
  acl          = "public-read"
  content_type = "text/html"

}

resource "aws_s3_bucket_object" "error" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "error.html"
  source       = "html/error.html"
  acl          = "public-read"
  content_type = "text/html"

}
