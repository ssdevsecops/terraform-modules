terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-est-1"
}

resource "aws_instance" "example" {
  ami           = "ami-005c06c6de69aee84"
  instance_type = "t2.micro"
}