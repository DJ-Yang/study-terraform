provider "aws" {
  region = "ap-northeast-2" # Please use the default region ID
  version = "~> 2.49.0" # Please choose any version or delete this line if you want the latest version
}

# S3 bucket for backend
resource "aws_s3_bucket" "tfstate" {
  bucket = "tf101-jupiter-apne2-tfstate-dj"

  versioning {
    enabled = true # Prevent from deleting tfstate file
  }
}

# DynamoDB for terraform state lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-lock"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}
