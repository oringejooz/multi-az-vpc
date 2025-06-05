resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids

  tags = merge(var.common_tags, { Name = "S3-Gateway-Endpoint" })
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids

  tags = merge(var.common_tags, { Name = "DynamoDB-Gateway-Endpoint" })
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids
  security_group_ids = [var.endpoint_sg_id]

  private_dns_enabled = true

  tags = merge(var.common_tags, { Name = "EC2-Interface-Endpoint" })
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids
  security_group_ids = [var.endpoint_sg_id]

  private_dns_enabled = true

  tags = merge(var.common_tags, { Name = "SSM-Interface-Endpoint" })
}
