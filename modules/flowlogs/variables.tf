variable "vpc_id" {
  description = "The ID of the VPC for which to enable flow logs"
  type        = string
}

variable "common_tags" {
  description = "Common tags for resources"
  type        = map(string)
  default     = {}
}
