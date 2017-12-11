resource "aws_subnet" "connectivity_tester_subnet" {
  vpc_id                  = "${aws_vpc.peeringvpc.id}"
  cidr_block              = "${var.connectivity_tester_subnet_cidr_block}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}connectivity-tester-subnet"
  }
}

module "peering_connectivity_tester" {
  source          = "github.com/ukhomeoffice/connectivity-tester-tf"
  subnet_id       = "${aws_subnet.connectivity_tester_subnet.id}"
  user_data       = "LISTEN_tcp=0.0.0.0:80"
  security_groups = ["${aws_security_group.connectivity_tester.id}"]
  private_ip      = "${var.peering_connectivity_tester_ip}"

  tags = {
    Name             = "ec2-${var.service}-connectivity-tester-${var.environment}"
    Service          = "${var.service}"
    Environment      = "${var.environment}"
    EnvironmentGroup = "${var.environment_group}"
  }
}

resource "aws_security_group" "connectivity_tester" {
  vpc_id = "${aws_vpc.peeringvpc.id}"

  tags {
    Name = "${local.name_prefix}connectivity-sg"
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "${var.SGCIDRs}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
