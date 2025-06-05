resource "aws_eip" "nat" {
  for_each = var.public_subnets

  domain = "vpc"

  tags = {
    Name = "NAT-EIP-${each.key}"
  }
}

resource "aws_nat_gateway" "nat" {
  for_each = var.public_subnets

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value
  depends_on    = [aws_eip.nat]

  tags = {
    Name = "NAT-Gateway-${each.key}"
  }
}
