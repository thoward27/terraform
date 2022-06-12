
locals {
  ssh_ip_list = var.use_public_ip_for_ssh == "true" ? join(
    " ", aws_instance.yugabyte_nodes.*.public_ip,
  ) : join(" ", aws_instance.yugabyte_nodes.*.private_ip)
  config_ip_list = join(" ", aws_instance.yugabyte_nodes.*.private_ip)
  az_list        = join(" ", aws_instance.yugabyte_nodes.*.availability_zone)
}

resource "null_resource" "create_yugabyte_universe" {
  # Define the trigger condition to run the resource block
  triggers = {
    cluster_instance_ids = join(",", aws_instance.yugabyte_nodes.*.id)
  }

  # Execute after the nodes are provisioned and the software installed.
  depends_on = [aws_instance.yugabyte_nodes]

  provisioner "local-exec" {
    # Bootstrap script called with private_ip of each node in the clutser
    command = "${path.module}/utilities/scripts/create_universe.sh 'aws' '${var.aws_region}' ${var.replication_factor} '${local.config_ip_list}' '${local.ssh_ip_list}' '${local.az_list}' ${var.ssh_user} ${var.ssh_private_key}"
  }
}
