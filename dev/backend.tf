terraform {
  backend "s3" {
    bucket = "64bucketlane"
    key    = "dev-state/terraform.tfstate"
    region = "us-west-2"
  }
}