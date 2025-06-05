output "public_subnets" {
  value = aws_subnet.public
}

output "private_subnets" {
  value = aws_subnet.private
}

output "database_subnets" {
  value = aws_subnet.database
}

output "public_subnet_ids" {
  value = { for k, v in aws_subnet.public : k => v.id }
}

