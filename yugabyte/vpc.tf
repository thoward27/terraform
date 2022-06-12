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
  count             = var.num_instances
  availability_zone = element(var.aws_availability_zones[var.aws_region], count.index)
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = aws_vpc.prod.id
}

/// Security Groups.

resource "aws_security_group" "yugabyte_external" {
  name   = "${var.cluster_name}-external"
  vpc_id = aws_vpc.prod.id

  ingress {
    from_port   = 7000
    to_port     = 7000
    protocol    = "tcp"
    self        = true
    cidr_blocks = var.allowed_sources
  }
  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    self        = true
    cidr_blocks = var.allowed_sources
  }
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    self        = true
    cidr_blocks = var.allowed_sources
  }
  ingress {
    from_port   = 9042
    to_port     = 9042
    protocol    = "tcp"
    self        = true
    cidr_blocks = var.allowed_sources
  }
  ingress {
    from_port   = 5433
    to_port     = 5433
    protocol    = "tcp"
    self        = true
    cidr_blocks = var.allowed_sources
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    self        = true
    cidr_blocks = var.allowed_sources
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Service = "yugabyte"
  }
}

resource "aws_security_group" "yugabyte_intra" {
  name   = "${var.cluster_name}-intra"
  vpc_id = aws_vpc.prod.id
  ingress {
    from_port = 7100
    to_port   = 7100
    protocol  = "tcp"
    self      = true
  }
  ingress {
    from_port = 9100
    to_port   = 9100
    protocol  = "tcp"
    self      = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Service = "yugabyte"
  }
}
