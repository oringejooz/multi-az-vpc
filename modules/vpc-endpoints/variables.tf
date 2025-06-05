variable "vpc_id" {
  type = string
}

variable "region" {
  type = string
}

variable "route_table_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "endpoint_sg_id" {
  description = "Security group for interface endpoints"
  type        = string
}

variable "common_tags" {
  type = map(string)
}
