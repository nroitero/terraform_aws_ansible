# Create a subnet to launch our instances into
resource "aws_subnet" "private" {
  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}
