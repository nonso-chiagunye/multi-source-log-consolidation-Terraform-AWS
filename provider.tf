
# Initialize Terraform with a defined version. Latest version will be used if this part is not included
# terraform {
#   required_version = ">= 1.0.10"
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 3.64"
#     }
#   }
# }

# Specify remote backend where state file is stored
terraform {
  required_version = "~> 1.0"

  backend "s3" {
    bucket         = "bucket_name"
    key            = "state_location"
    region         = "aws_region"
    dynamodb_table = "state_lock"
    encrypt        = "true"
  }
}

# Define AWS Region 
provider "aws" {
    region = var.AWS_REGION 
}
