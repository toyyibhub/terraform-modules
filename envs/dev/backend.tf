terraform {
  backend "s3" {
    bucket         = "toyyib-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    profile        = "toyyib"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}