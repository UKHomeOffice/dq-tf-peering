provider "aws" {}

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

  tags {
    Name = "${local.name_prefix}route-table"
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
