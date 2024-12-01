terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket  = "tech-challenge-database-bucket-state-tf"
    region  = "us-east-1"
    key     = "terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  profile = "lab-academy" # Profile name in the credentials file
  region  = "us-east-1"   # Region to deploy the resources
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_bucket

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.bucket

  versioning_configuration {
    status = "Enabled"
  }

  depends_on = [
    aws_s3_bucket.terraform_state
  ]
}
