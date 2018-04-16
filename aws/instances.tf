data "aws_availability_zones" "available" {}

resource "aws_instance" "server" {
  tags {
    Name = "app-${count.index}"

    # Role = "vpn"
  }

  ami = "${data.aws_ami.image.id}"

  # availability_zone      = "${data.aws_availability_zones.available.names[0]}"
  iam_instance_profile   = "${ aws_iam_instance_profile.role.name }"
  instance_type          = "t2.micro"
  key_name               = "${module.ssh_key_pair.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id              = "${aws_subnet.subnet.id}"
  monitoring             = true
  count                  = "${var.server_count}"

  #### ensure python is installed for ansible deployment (needed by gather_facts: true)
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y python",
    ]
  }

  ##### test ebs detach attach with delay  ###DO NOT UNCOMMENT
  #sleep ${count.index*120}
  #  aws ec2 detach-volume --volume-id=${element(aws_ebs_volume.ebs.*.id,count.index)} --region=${var.region}
  #    sleep 10
  #    aws ec2 attach-volume --instance-id=${self.id} --volume-id=${element(aws_ebs_volume.ebs.*.id,count.index)} --device=/dev/xvdh --region=${var.region}
  provisioner "local-exec" {
    command = <<BAR
ansible-galaxy install -r ansible/requirements.yml
  ansible-playbook -u ubuntu  --extra-vars 'hostname=app-${count.index}.${var.domain}' --private-key secrets/${module.ssh_key_pair.key_name}.pem -i '${self.public_ip},' ansible/master.yml ${var.ansible_verbosity}
BAR
  }

  # echo -e \"[default]\n${self.public_ip} ansible_connection=ssh ansible_ssh_user=root\" 

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
