terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.6"
    }
  }

  backend "s3" {
    bucket         = "ecom-st-bucket"
    key            = "state"
    region         = "ap-southeast-1"
    dynamodb_table = "ecom-st-table"
  }
}
