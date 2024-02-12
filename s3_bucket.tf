# main.tf

provider "aws" {
  region = "ap-south-1" # Change the region accordingly
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "kishore-test1-160988" # Change this to a globally unique name
  acl    = "private" # Access Control List (private in this example)

  tags = {
    Name        = "MyS3Bucket"
    Environment = "Production"
  }
}
