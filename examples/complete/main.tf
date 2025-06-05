 module "vpc" {
  source   = "../../modules/vpc"
  vpc_cidr = var.vpc_cidr
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
