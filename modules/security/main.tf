# Public Network ACL
resource "aws_network_acl" "public" {
  vpc_id = var.vpc_id

  tags = merge(var.common_tags, { Name = "Public-NACL" })
}

resource "aws_network_acl_rule" "public_inbound" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress        = false
  protocol      = "-1"
  rule_action   = "allow"
  cidr_block    = "0.0.0.0/0"
  from_port     = 0
  to_port       = 0
}

resource "aws_network_acl_rule" "public_outbound" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress        = true
  protocol      = "-1"
  rule_action   = "allow"
  cidr_block    = "0.0.0.0/0"
  from_port     = 0
  to_port       = 0
}

# Private Network ACL
resource "aws_network_acl" "private" {
  vpc_id = var.vpc_id

  tags = merge(var.common_tags, { Name = "Private-NACL" })
}

resource "aws_network_acl_rule" "private_inbound" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress        = false
  protocol      = "-1"
  rule_action   = "allow"
  cidr_block    = var.vpc_cidr
  from_port     = 0
  to_port       = 0
}

resource "aws_network_acl_rule" "private_outbound" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress        = true
  protocol      = "-1"
  rule_action   = "allow"
  cidr_block    = "0.0.0.0/0"
  from_port     = 0
  to_port       = 0
}

# Database Network ACL (more restrictive example)
resource "aws_network_acl" "database" {
  vpc_id = var.vpc_id

  tags = merge(var.common_tags, { Name = "Database-NACL" })
}

resource "aws_network_acl_rule" "database_inbound" {
  network_acl_id = aws_network_acl.database.id
  rule_number    = 100
  egress        = false
  protocol      = "-1"
  rule_action   = "allow"
  cidr_block    = var.vpc_cidr
  from_port     = 0
  to_port       = 0
}

resource "aws_network_acl_rule" "database_outbound" {
  network_acl_id = aws_network_acl.database.id
  rule_number    = 100
  egress        = true
  protocol      = "-1"
  rule_action   = "allow"
  cidr_block    = "0.0.0.0/0"
  from_port     = 0
  to_port       = 0
}

# Network ACL Associations

resource "aws_network_acl_association" "public" {
  for_each = var.public_subnet_ids

  subnet_id      = each.value
  network_acl_id = aws_network_acl.public.id
}

resource "aws_network_acl_association" "private" {
  for_each = var.private_subnet_ids

  subnet_id      = each.value
  network_acl_id = aws_network_acl.private.id
}

resource "aws_network_acl_association" "database" {
  for_each = var.database_subnet_ids

  subnet_id      = each.value
  network_acl_id = aws_network_acl.database.id
}

resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "web-sg" })
}

resource "aws_security_group" "app" {
  name        = "app-sg"
  description = "Allow internal communication from web and app"
  vpc_id      = var.vpc_id

  # Allow traffic from web SG
  ingress {
    description     = "From web SG"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.web.id]
  }
  
  # NOTE: self-referential rule moved out to a separate resource below

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "app-sg" })
}

# Separate self-referential security group rule for app SG
resource "aws_security_group_rule" "app_self_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.app.id
  source_security_group_id = aws_security_group.app.id
  description              = "Allow traffic from within app security group"
}

resource "aws_security_group" "db" {
  name        = "db-sg"
  description = "Allow DB access only from app SG"
  vpc_id      = var.vpc_id

  ingress {
    description     = "From app SG"
    from_port       = 3306  # Adjust as per your DB port (e.g., 5432 for Postgres)
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "db-sg" })
}

resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "Allow SSH access from trusted CIDRs"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_cidr_blocks  # Make sure you pass a valid CIDR list here, e.g., ["203.0.113.25/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "bastion-sg" })
}
