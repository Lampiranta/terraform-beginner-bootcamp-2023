terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  #backend "remote" {
  #  hostname = "app.terraform.io"
  #  organization = "ExamPro"

  #  workspaces {
  #    name = "terra-house-1"
  #  }
  #}
  #cloud {
  #  organization = "ExamPro"
  #  workspaces {
  #    name = "terra-house-1"
  #  }
  #}
}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}


module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version = var.content_version
  assets_path = var.assets_path
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
  domain_name = module.terrahouse_aws.cloudfront_url
  town = "missingo"
  content_version = 1
}