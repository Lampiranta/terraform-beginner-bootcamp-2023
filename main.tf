terraform {

}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
  
#resource "aws_s3_bucket" "website_bucket" {
#  # (resource arguments)
#}