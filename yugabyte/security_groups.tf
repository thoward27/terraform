resource "aws_security_group" "yugabyte_external" {
  name   = "${var.cluster_name}-external"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

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
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

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
