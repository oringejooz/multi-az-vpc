resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "PublicRouteTable"
    Tier = "Public"
  })
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

resource "aws_route_table" "private" {
  for_each = var.private_subnet_ids
  vpc_id   = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "PrivateRouteTable-${each.key}"
    Tier = "Private"
  })
}

resource "aws_route" "private_nat_access" {
  for_each = var.private_subnet_ids

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_ids[local.private_to_public_subnet_key[each.key]]
}


resource "aws_route_table" "database" {
  for_each = var.database_subnet_ids
  vpc_id   = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "DatabaseRouteTable-${each.key}"
    Tier = "Database"
  })
}

# No routes for database route tables (isolated)

resource "aws_route_table_association" "public_associations" {
  for_each       = var.public_subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_associations" {
  for_each       = var.private_subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route_table_association" "database_associations" {
  for_each       = var.database_subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.database[each.key].id
}
