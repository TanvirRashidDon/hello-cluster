resource "aws_vpc" "hello_vpc" { # logical network isolation
  cidr_block = local.vpc_cidr_block

  tags = {
    Name = "${terraform.workspace}-hello-app"
    app  = "hello-app"
    type = "aws_vpc"
  }
}

##- make vpc available to the internet
resource "aws_internet_gateway" "gateway" { # internet acess capabelity
  vpc_id = aws_vpc.hello_vpc.id

  tags = {
    Name = "${terraform.workspace}-hello-app"
    app  = "hello-app"
    type = "aws_internet_gateway"
  }
}

resource "aws_route_table" "public" { # allow internet access
  vpc_id = aws_vpc.hello_vpc.id

  route {
    cidr_block = local.ingress_cidr_block
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "${terraform.workspace}-hello-app"
    app  = "hello-app"
    type = "aws_route_table"
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.hello_vpc.id
  route_table_id = aws_route_table.public.id
}

##- subneting
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.hello_vpc.id
  cidr_block        = local.public_subnet_cidr_block
  availability_zone = "${var.region}a"

  tags = {
    Name = "${terraform.workspace}-hello-app"
    app  = "hello-app"
    type = "aws_subnet"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}
