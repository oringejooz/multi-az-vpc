resource "aws_vpc_dhcp_options" "custom_dhcp" {
  domain_name         = var.domain_name
  domain_name_servers = var.domain_name_servers
  ntp_servers         = var.ntp_servers

  tags = merge(var.common_tags, {
    Name = "custom-dhcp-options"
  })
}

resource "aws_vpc_dhcp_options_association" "dhcp_assoc" {
  vpc_id          = var.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.custom_dhcp.id
}
