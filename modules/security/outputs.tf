output "web_sg_id" {
  value = aws_security_group.web.id
}

output "app_sg_id" {
  value = aws_security_group.app.id
}

output "db_sg_id" {
  value = aws_security_group.db.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion.id
}

output "public_nacl_id" {
  value = aws_network_acl.public.id
}

output "private_nacl_id" {
  value = aws_network_acl.private.id
}

output "database_nacl_id" {
  value = aws_network_acl.database.id
}
