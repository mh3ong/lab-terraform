provider "aws" {
  #Tokyo region
  region = "ap-northeast-1"
  profile = "ddpslab"
}

module "vpc" {
  source = "./vpc"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  region_azs = data.aws_availability_zones.region_azs.names
  public_subnet_number = var.public_subnet_number
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_number = var.private_subnet_number
  private_subnet_cidrs = var.private_subnet_cidrs
  key_name = var.key_name
}