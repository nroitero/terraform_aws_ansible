output "instance ips" {
  value = ["${aws_instance.server.*.public_ip}"]
}

output "load balancer dns name" {
  value = "${aws_elb.elb.*.dns_name}"
}
