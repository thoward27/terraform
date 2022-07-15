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

# Routing for all subnets not explicitly associated with any other route table.
resource "aws_main_route_table_association" "prod" {
  vpc_id         = aws_vpc.prod.id
  route_table_id = aws_route_table.prod_external.id
}

# Routing to external facing subnets.
resource "aws_route_table_association" "prod_external" {
  count          = var.aws_az_span_count
  subnet_id      = aws_subnet.prod_external.*.id[count.index]
  route_table_id = aws_route_table.prod_external.id
}

# Routing to internal only subnets.
resource "aws_route_table_association" "prod_internal" {
  count          = var.aws_az_span_count
  subnet_id      = aws_subnet.prod_internal.*.id[count.index]
  route_table_id = aws_route_table.prod_external.id
}

/// Subnets.

resource "aws_subnet" "prod_internal" {
  count             = var.aws_az_span_count
  availability_zone = element(var.aws_availability_zones[var.aws_region], count.index)
  cidr_block        = cidrsubnet(var.internal_cidr_block, 4, count.index)
  vpc_id            = aws_vpc.prod.id
}

resource "aws_subnet" "prod_external" {
  count                   = var.aws_az_span_count
  availability_zone       = element(var.aws_availability_zones[var.aws_region], 0)
  cidr_block              = cidrsubnet(var.external_cidr_block, 4, count.index)
  vpc_id                  = aws_vpc.prod.id
  map_public_ip_on_launch = true
}
