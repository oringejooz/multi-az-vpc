output "nat_gateway_ids" {
  value = { for k, v in aws_nat_gateway.nat : k => v.id }
}
