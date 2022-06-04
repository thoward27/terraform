
resource "aws_key_pair" "terraform_yugabyte" {
  key_name   = "terraform-yugabyte"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKInn8iWpWWPIi4JXMB9So54UDIqXTSeUnaDm7FUoXlY"
}

resource "aws_vpc" "prod_main" {
  cidr_block = "10.0.0.0/16"
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

resource "local_file" "private_key" {
  filename        = "${path.module}/yugabyte.key"
  content_base64  = var.ssh_key
  file_permission = "0400"
}

module "yugabyte_db_cluster" {
  source             = "github.com/yugabyte/terraform-aws-yugabyte"
  cluster_name       = "prod-main-yb1-use1"
  ssh_keypair        = aws_key_pair.terraform_yugabyte.key_name
  ssh_private_key    = local_file.private_key.filename
  instance_type      = "t3.medium"
  num_instances      = "3"
  replication_factor = "3"
  region_name        = "us-east-1"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  subnet_ids         = [aws_subnet.prod_main_use1a.id, aws_subnet.prod_main_use1b.id, aws_subnet.prod_main_use1c.id]
  vpc_id             = aws_vpc.prod_main.id
}
