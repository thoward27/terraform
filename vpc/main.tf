resource "aws_vpc" "prod" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "prod" {
  vpc_id = aws_vpc.prod.id
}

resource "aws_route_table" "prod_external" {
  vpc_id = aws_vpc.prod.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod.id
  }
  tags = {
    Name = "prod_external"
  }
}

/// Route table associations.

resource "aws_main_route_table_association" "prod_external" {
  vpc_id         = aws_vpc.prod.id
  route_table_id = aws_route_table.prod_external.id
}

/// Subnets.

resource "aws_subnet" "prod" {
  count             = var.aws_subnets
  availability_zone = element(var.aws_availability_zones[var.aws_region], count.index)
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = aws_vpc.prod.id
}
