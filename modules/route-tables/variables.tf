variable "vpc_id" {
  type = string
}

variable "igw_id" {
  type = string
}

variable "nat_gateway_ids" {
  description = "Map of NAT Gateway IDs keyed by private subnet keys"
  type        = map(string)
}

variable "public_subnet_ids" {
  description = "Map of public subnet keys to subnet IDs"
  type        = map(string)
}

variable "private_subnet_ids" {
  description = "Map of private subnet keys to subnet IDs"
  type        = map(string)
}

variable "private_subnet_keys" {
  description = "List of keys for private subnets"
  type        = list(string)
}

variable "database_subnet_ids" {
  description = "Map of database subnet keys to subnet IDs"
  type        = map(string)
}

variable "database_subnet_keys" {
  description = "List of keys for database subnets"
  type        = list(string)
}

variable "common_tags" {
  type = map(string)
}

locals {
  private_to_public_subnet_key = {
    "private-1a" = "public-1a"
    "private-1b" = "public-1b"
  }
}
