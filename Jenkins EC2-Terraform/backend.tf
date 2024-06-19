terraform {
  backend "s3" {
    bucket = "backend_s3_storage" # Replace with your actual S3 bucket name
    key    = "Jenkins/terraform.tfstate"
    region = "ap-south-1"
  }
}
