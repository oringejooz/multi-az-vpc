provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "subnets" {
  source = "./modules/subnets"

  vpc_id = module.vpc.vpc_id

  public_subnets = {
    "public-1a" = {
      cidr_block = "10.0.1.0/24"
      az         = "ap-south-1a"
      name       = "public-1a"
    }
    "public-1b" = {
      cidr_block = "10.0.2.0/24"
      az         = "ap-south-1b"
      name       = "public-1b"
    }
  }

  private_subnets = {
    "private-1a" = {
      cidr_block = "10.0.11.0/24"
      az         = "ap-south-1a"
      name       = "private-1a"
    }
    "private-1b" = {
      cidr_block = "10.0.12.0/24"
      az         = "ap-south-1b"
      name       = "private-1b"
    }
  }

  database_subnets = {
    "db-1a" = {
      cidr_block = "10.0.21.0/24"
      az         = "ap-south-1a"
      name       = "db-1a"
    }
    "db-1b" = {
      cidr_block = "10.0.22.0/24"
      az         = "ap-south-1b"
      name       = "db-1b"
    }
  }

  common_tags = {
    Project = "MultiAZ-VPC"
    Owner   = "Swarnima"
    Env     = "Production"
  }
}

module "nat_gateway" {
  source = "./modules/nat-gateway"

  public_subnets = {
    "public-1a" = module.subnets.public_subnet_ids["public-1a"]
    "public-1b" = module.subnets.public_subnet_ids["public-1b"]
  }
}
