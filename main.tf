terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
}

#module "terrahouse_aws" {
#  source = "./modules/terrahouse_aws"
#  user_uuid = var.user_uuid
#  bucket_name = var.bucket_name
#  index_html_filepath = var.index_html_filepath
#  error_html_filepath = var.error_html_filepath
#  assets_path = var.assets_path
#  content_version = var.content_version
#}
  
provider "terratowns" {
  endpoint = "http://localhost:4567/api"
  user_uuid="e328f4ab-b99f-421c-84c9-4ccea042c7d1" 
  token="9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}

#resource "aws_s3_bucket" "website_bucket" {
#  # (resource arguments)
#}

resource "terratowns_home" "home" {
  name = "The Lord of the Rings The Card Game"
  description = <<DESCRIPTION
The Lord of the Rings The Card Game is a living card game by Fantasy Flight Games.
It is a cooperative card game in a fantasy world created by Professor J.R.R Tolkien.
DESCRIPTION
  #domain_name = module.terrahouse_aws.cloudfront_url
  domain_name = "3fdq3gz.cloudfront.net"
  town = "gamers-grotto"
  content_version = 1
}