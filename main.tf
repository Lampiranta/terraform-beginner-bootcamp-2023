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
  endpoint = "http://terratowns.cloud/api"
  user_uuid="857dd0d8-d5ef-42e3-b355-7139ef541bf4" 
  token="10346f5f-8a12-45e1-aa98-fe0b0fe9649d"
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