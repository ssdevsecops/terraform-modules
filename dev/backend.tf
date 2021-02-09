terraform {
  backend "s3" {
    bucket = "64bucketlane"
    key    = "dev/terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "terraformstate"
  }
}
