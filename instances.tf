variable instance_type {
  default = "t2.nano"
}

data "aws_ami" "linux_connectivity_tester" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "connectivity-tester-linux*",
    ]
  }

  owners = [
    "093401982388",
  ]
}

resource "aws_instance" "connectivity_tester" {
  ami                    = "${data.aws_ami.linux_connectivity_tester.id}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${aws_subnet.connectivity_tester_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.connectivity_tester.id}"]

  tags {
    Name = "${local.name_prefix}ec2-linux"
  }

  user_data = "CHECK_self=127.0.0.1:8080 CHECK_google=google.com:80 CHECK_googletls=google.com:443 LISTEN_http=0.0.0.0:80"
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
      "${var.opssubnet_cidr_block}",
      "${var.acpcicd_vpc_subnet_cidr_block}",
      "${var.acpops_vpc_subnet_cidr_block}",
      "${var.acpprod_vpc_subnet_cidr_block}",
      "${var.acpvpn_vpc_subnet_cidr_block}",
      "${var.data_ingest_cidr_block}",
      "${var.data_pipe_apps_cidr_block}",
      "${var.data_feeds_cidr_block}",
      "${var.public_subnet_cidr_block}",
      "${var.dgdb_apps_cidr_block}",
      "${var.mdm_apps_cidr_block}",
      "${var.int_dashboard_cidr_block}",
      "${var.ext_dashboard_cidr_block}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
