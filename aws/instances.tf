data "aws_availability_zones" "available" {}

resource "aws_instance" "server" {
  tags {
    Name = "app-${count.index}"
  }

  ami = "${data.aws_ami.image.id}"

  # availability_zone      = "${data.aws_availability_zones.available.names[0]}"
  instance_type          = "t2.micro"
  key_name               = "${module.ssh_key_pair.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id              = "${aws_subnet.private.id}"
  monitoring             = true
  count                  = "${var.server_count}"

  #### ensure python is installed for ansible deployment (needed by gather_facts: true)
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y python",
    ]
  }

  #### use of aws command line tool to solve https://github.com/hashicorp/terraform/issues/2957
  #### unmount volume from old instance and mount it on new one before running ansible
  provisioner "local-exec" {
    command = "tools/provision.sh  ${var.with_volume_attached} ${self.id} ${var.region} ${count.index} ${var.domain} ${module.ssh_key_pair.key_name} ${self.public_ip} ${var.ansible_verbosity}  ${  length(aws_ebs_volume.ebs.*.id) > 0   ? element(aws_ebs_volume.ebs.*.id,count.index) : ""}"
  }

  connection {
    user        = "ubuntu"
    type        = "ssh"
    agent       = "true"
    timeout     = "10m"
    private_key = "${file("secrets/${module.ssh_key_pair.key_name}.pem")}"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["ami"]
  }
}
