variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "domain_name" {
  description = "Domain name for DHCP option set"
  type        = string
}

variable "domain_name_servers" {
  description = "List of DNS servers"
  type        = list(string)
}

variable "ntp_servers" {
  description = "List of NTP servers"
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Common tags for resources"
  type        = map(string)
  default     = {}
}
