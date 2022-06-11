

resource "aws_vpc" "prod_main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "prod_main" {
  vpc_id = aws_vpc.prod_main.id
}

resource "aws_route_table" "prod_main_external" {
  vpc_id = aws_vpc.prod_main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod_main.id
  }
}

resource "aws_main_route_table_association" "prod_main" {
  vpc_id         = aws_vpc.prod_main.id
  route_table_id = aws_route_table.prod_main_external.id
}

resource "aws_subnet" "prod_main_use1a" {
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.prod_main.id
}

resource "aws_subnet" "prod_main_use1b" {
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.prod_main.id
}

resource "aws_subnet" "prod_main_use1c" {
  availability_zone = "us-east-1c"
  cidr_block        = "10.0.3.0/24"
  vpc_id            = aws_vpc.prod_main.id
}

