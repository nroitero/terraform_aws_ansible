# resource "aws_ebs_volume" "ebs" {
#   availability_zone = "${data.aws_availability_zones.available.names[0]}"
#   count             = "${var.server_count}"
#   size              = 1
#   type              = "gp2"
#   tags {
#     Name = "volume-${count.index}"
#   }
# }
# resource "aws_volume_attachment" "ebs_att" {
#   count       = "${var.server_count}"
#   device_name = "/dev/xvdh"
#   volume_id   = "${element(aws_ebs_volume.ebs.*.id,count.index)}"
#   instance_id = "${element(aws_instance.server.*.id,count.index)}"
#   # skip_destroy = true
#   # lifecycle {
#   #   create_before_destroy = true
#   #   ignore_changes = ["volume_id", "instance_id"]
#   # }
# }

