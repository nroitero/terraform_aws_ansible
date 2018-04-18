resource "aws_ebs_volume" "ebs" {
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  count             = "${var.with_volume_attached ? var.server_count : "0"}"
  size              = 1
  type              = "gp2"

  tags {
    Name = "volume-${count.index}"
  }
}

### not necessary anymore instead we are attaching volumes with provision.sh because of  https://github.com/hashicorp/terraform/issues/2957


# resource "aws_volume_attachment" "ebs_att" {
#   count       = "${var.with_volume_attached ? var.server_count : "0"}"
#   device_name = "/dev/xvdh"
#   volume_id   = "${element(aws_ebs_volume.ebs.*.id,count.index)}"
#   instance_id = "${element(aws_instance.server.*.id,count.index)}"
#   skip_destroy = true
#   lifecycle {
#     ignore_changes = ["instance_id"]
#   }
# }

