resource "aws_elb" "elb" {
  name                        = "load-balancer"
  subnets                     = ["${aws_subnet.private.id}"]
  security_groups             = ["${aws_security_group.elb.id}"]
  instances                   = ["${aws_instance.server.*.id}"]
  connection_draining         = true
  connection_draining_timeout = 400

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 5
  }
}

resource "aws_security_group" "elb" {
  name        = "security_elb"
  description = "load balancer security settings"
  vpc_id      = "${aws_vpc.main.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
