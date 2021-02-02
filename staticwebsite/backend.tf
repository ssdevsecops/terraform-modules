terraform {
  backend "s3" {
    bucket = "64bucketlane"
    key    = "staticwebsite/terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "terraformstate"
  }
}