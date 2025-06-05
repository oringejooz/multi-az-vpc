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

module "route_tables" {
  source = "./modules/route-tables"

  vpc_id              = module.vpc.vpc_id
  igw_id              = module.vpc.igw_id
  nat_gateway_ids     = module.nat_gateway.nat_gateway_ids
  public_subnet_ids   = module.subnets.public_subnet_ids
  private_subnet_ids  = module.subnets.private_subnet_ids
  private_subnet_keys = keys(module.subnets.private_subnet_ids)
  database_subnet_ids = module.subnets.database_subnet_ids
  database_subnet_keys = keys(module.subnets.database_subnet_ids)
  common_tags         = {
    Project = "MultiAZ-VPC"
    Owner   = "Swarnima"
    Env     = "Production"
  }
}

module "security" {
  source = "./modules/security"

  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.vpc_cidr
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  database_subnet_ids = module.subnets.database_subnet_ids
  bastion_cidr_blocks = ["3.143.78.38/32"] # restrict accordingly
  common_tags        = {
    Project = "MultiAZ-VPC"
    Owner   = "Swarnima"
    Env     = "Production"
  }
}

module "vpc_endpoints" {
  source = "./modules/vpc-endpoints"

  vpc_id             = module.vpc.vpc_id
  region             = var.region
  route_table_ids    = [module.route_tables.public_route_table_id] # Gateway endpoints need route tables
  private_subnet_ids = values(module.subnets.private_subnet_ids)
  endpoint_sg_id     = module.security.app_sg_id
  common_tags        = {
    Project = "MultiAZ-VPC"
    Owner   = "Swarnima"
    Env     = "Production"
  }
}

module "flowlogs" {
  source      = "./modules/flowlogs"
  vpc_id      = module.vpc.vpc_id
  common_tags = var.common_tags
}

module "dhcp" {
  source               = "./modules/dhcp"
  vpc_id               = module.vpc.vpc_id
  domain_name          = "example.internal"
  domain_name_servers  = ["AmazonProvidedDNS"]
  ntp_servers          = ["169.254.169.123"]
  common_tags          = var.common_tags
}
