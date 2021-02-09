terraform {
  backend "s3" {
    bucket = "64bucketlane"
    key    = "admin/terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "terraformstate"
  }
}
