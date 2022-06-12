
// SSH Key management.
resource "aws_key_pair" "terraform_yugabyte" {
  key_name   = "terraform-yugabyte"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKInn8iWpWWPIi4JXMB9So54UDIqXTSeUnaDm7FUoXlY"
}

resource "local_file" "ssh_private_key" {
  filename        = "${path.module}/yugabyte.key"
  content_base64  = var.ssh_private_key
  file_permission = "0400"
}

resource "aws_instance" "yugabyte_nodes" {
  count                       = var.num_instances
  ami                         = data.aws_ami.yugabyte_ami.id
  associate_public_ip_address = var.associate_public_ip_address
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.terraform_yugabyte.key_name
  availability_zone           = element(var.aws_availability_zones[var.aws_region], count.index)
  subnet_id                   = aws_subnet.prod[count.index].id
  vpc_security_group_ids = [
    aws_security_group.yugabyte_external.id,
    aws_security_group.yugabyte_intra.id,
  ]
  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp2"
    iops        = 0
  }
  tags = {
    Service = "yugabyte"
  }

  provisioner "file" {
    source      = "${path.module}/utilities/scripts/install_software.sh"
    destination = "/home/${var.ssh_user}/install_software.sh"
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(local_file.ssh_private_key.filename)
    }
  }

  provisioner "file" {
    source      = "${path.module}/utilities/scripts/create_universe.sh"
    destination = "/home/${var.ssh_user}/create_universe.sh"
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(local_file.ssh_private_key.filename)
    }
  }

  provisioner "file" {
    source      = "${path.module}/utilities/scripts/start_tserver.sh"
    destination = "/home/${var.ssh_user}/start_tserver.sh"
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(local_file.ssh_private_key.filename)
    }
  }

  provisioner "file" {
    source      = "${path.module}/utilities/scripts/start_master.sh"
    destination = "/home/${var.ssh_user}/start_master.sh"

    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(local_file.ssh_private_key.filename)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.ssh_user}/install_software.sh",
      "chmod +x /home/${var.ssh_user}/create_universe.sh",
      "chmod +x /home/${var.ssh_user}/start_tserver.sh",
      "chmod +x /home/${var.ssh_user}/start_master.sh",
      "sudo yum install -y wget",
      "/home/${var.ssh_user}/install_software.sh '${var.yb_version}'",
    ]
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(local_file.ssh_private_key.filename)
    }
  }

  lifecycle {
    create_before_destroy = false # TODO: Change to true once testing is done.
  }
}
