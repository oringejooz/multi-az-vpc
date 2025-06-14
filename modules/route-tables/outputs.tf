output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_ids" {
  value = aws_route_table.private
}

output "database_route_table_ids" {
  value = aws_route_table.database
}
