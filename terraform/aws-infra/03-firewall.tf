##- subnet firewall (stateless)
resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.hello_vpc.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = local.ingress_cidr_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = local.egress_cidr_block
    from_port  = 0
    to_port    = 0
  }

  tags = {
    app  = "hello-app"
    type = "aws_default_network_acl"
  }
}

resource "aws_network_acl_association" "a" {
  network_acl_id = aws_default_network_acl.default.id
  subnet_id      = aws_subnet.public_subnet.id
}

##- object firewall (statefull)
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound and outbound traffic"
  vpc_id      = aws_vpc.hello_vpc.id

  tags = {
    Name = "${terraform.workspace}-hello-app"
    app  = "hello-app"
    type = "aws_security_group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ingress_http" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = local.ingress_cidr_block
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

# for debugging purpose. will not be part of production
resource "aws_vpc_security_group_ingress_rule" "allow_ingress_ssh" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = local.ingress_cidr_block
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = local.egress_cidr_block
  ip_protocol       = "-1"
}
