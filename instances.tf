module "peering_connectivity_tester" {
  source          = "github.com/ukhomeoffice/connectivity-tester-tf"
  subnet_id       = "${aws_subnet.connectivity_tester_subnet.id}"
  user_data       = "LISTEN_tcp=0.0.0.0:80 CHECK_ACP_PROD=${var.prod_tester_ip}:${var.acp_port} CHECK_ACP_OPS=${var.ops_tester_ip}:${var.acp_port} CHECK_ACP_CICD=${var.cicd_tester_ip}:${var.acp_port}"
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
