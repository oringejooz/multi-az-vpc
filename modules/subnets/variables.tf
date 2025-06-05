 variable "vpc_id" {}

variable "public_subnets" {
  description = "Map of public subnet configs"
  type        = map(object({
    cidr_block = string
    az         = string
    name       = string
  }))
}

variable "private_subnets" {
  description = "Map of private subnet configs"
  type        = map(object({
    cidr_block = string
    az         = string
    name       = string
  }))
}

variable "database_subnets" {
  description = "Map of database subnet configs"
  type        = map(object({
    cidr_block = string
    az         = string
    name       = string
  }))
}

variable "common_tags" {
  type = map(string)
}

