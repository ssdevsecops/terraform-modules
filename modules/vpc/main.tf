data "aws_availability_zones" "azs" {}


resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "myvpc"
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "myigw"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }

  tags = {
    Name = "mypublicroute"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.myvpc.id

   route {
    nat_gateway_id = aws_nat_gateway.mynatgateway.id
    cidr_block     = "0.0.0.0/0"
  }

  tags = {
    Name = "myprivateroutetable"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = 2
  cidr_block              = var.public_cidrs[count.index]
  vpc_id                  = aws_vpc.myvpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.azs.names[count.index]

  tags = {
    Name = "mypublicsubnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = 2
  cidr_block        = var.private_cidrs[count.index]
  vpc_id            = aws_vpc.myvpc.id
  availability_zone = data.aws_availability_zones.azs.names[count.index]

  tags = {
    Name = "myprivatesubnet ${count.index + 1}"
  }
}


resource "aws_route_table_association" "publicsubnetassociation" {
  count          = 2
  route_table_id = aws_route_table.public_route.id
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
}

resource "aws_route_table_association" "privatesubnetassociation" {
  count          = 2
  route_table_id = aws_route_table.private_route.id
  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
}

resource "aws_eip" "elastic_ip" {
  vpc = true
  depends_on = [aws_internet_gateway.myigw]
}

resource "aws_nat_gateway" "mynatgateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet.0.id
   depends_on    = [aws_internet_gateway.myigw]
}










