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
  cloud {
    organization = "Lampiranta"
    workspaces {
      name = "terra-house-1"
    }
  }
}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}


module "home_lotr_lcg_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.lotr_lcg.public_path
  content_version = var.lotr_lcg.content_version
}
  


#resource "aws_s3_bucket" "website_bucket" {
#  # (resource arguments)
#}

resource "terratowns_home" "home_lotr_lcg" {
  name = "The Lord of the Rings The Card Game"
  description = <<DESCRIPTION
The Lord of the Rings The Card Game is a living card game by Fantasy Flight Games.
It is a cooperative card game in a fantasy world created by Professor J.R.R Tolkien.
DESCRIPTION
  #domain_name = module.terrahome_aws.cloudfront_url
  domain_name = module.home_lotr_lcg_hosting.domain_name
  town = "missingo"
  content_version = var.lotr_lcg.content_version
}


module "home_lovecraftian_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.lovecraftian.public_path
  content_version = var.lovecraftian.content_version
}

resource "terratowns_home" "home_lovecraftian" {
  name = "Music for your lovecraftian game nights"
  description = <<DESCRIPTION
Playing thematic horror tabletop games will benefit from finding great music to play in the background.
One of the best bands there is for this use case is none other than Ambient Jazz band Bohren & der Club of Gore. 
DESCRIPTION
  domain_name = module.home_lovecraftian_hosting.domain_name
  town = "missingo"
  content_version = var.lovecraftian.content_version
}
