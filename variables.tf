variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "access_key" {
}

variable "secret_key" {
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}


