data "aws_caller_identity" "current" {}

locals {
  name_prefix = "${var.name_prefix}peering-"
}

resource "aws_vpc" "peeringvpc" {
  cidr_block = "${var.cidr_block}"

  tags {
    Name = "${local.name_prefix}vpc"
  }
}

resource "aws_route_table" "peering_route_table" {
  vpc_id = "${aws_vpc.peeringvpc.id}"

  route {
    cidr_block = "${var.connectivity_tester_subnet_cidr_block}"
  }

  route {
    cidr_block = "${var.haproxy_subnet_cidr_block}"
  }

  route {
    cidr_block = "${var.acpcicd_vpc_subnet_cidr_block}"
  }

  route {
    cidr_block = "${var.acpops_vpc_subnet_cidr_block}"
  }

  route {
    cidr_block = "${var.acpprod_vpc_subnet_cidr_block}"
  }

  route {
    cidr_block = "${var.acpvpn_vpc_subnet_cidr_block}"
  }

  route {
    cidr_block = "${var.data_ingest_cidr_block}"
  }

  route {
    cidr_block = "${var.data_pipe_apps_cidr_block}"
  }

  route {
    cidr_block = "${var.data_feeds_cidr_block}"
  }

  route {
    cidr_block = "${var.public_subnet_cidr_block}"
  }

  route {
    cidr_block = "${var.dgdb_apps_cidr_block}"
  }

  route {
    cidr_block = "${var.mdm_apps_cidr_block}"
  }

  route {
    cidr_block = "${var.int_dashboard_cidr_block}"
  }

  route {
    cidr_block = "${var.ext_dashboard_cidr_block}"
  }

  tags {
    Name = "${local.name_prefix}route-table"
  }
}

resource "aws_subnet" "connectivity_tester_subnet" {
  vpc_id                  = "${aws_vpc.peeringvpc.id}"
  cidr_block              = "${var.connectivity_tester_subnet_cidr_block}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}connectivity-tester-subnet"
  }
}

resource "aws_subnet" "haproxy_subnet" {
  vpc_id                  = "${aws_vpc.peeringvpc.id}"
  cidr_block              = "${var.haproxy_subnet_cidr_block}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}haproxy-subnet"
  }
}
