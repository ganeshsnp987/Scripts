terraform {
  backend "s3" {
    bucket = "tetris-backend" # Replace with your actual S3 bucket name
    key    = "Jenkins/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "mydb_table"
  }
}
