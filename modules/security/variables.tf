variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "public_subnet_ids" {
  type = map(string)
}

variable "private_subnet_ids" {
  type = map(string)
}

variable "database_subnet_ids" {
  type = map(string)
}

variable "bastion_cidr_blocks" {
  description = "CIDR blocks allowed to SSH into bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"] 
}
