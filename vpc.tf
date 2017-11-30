variable "cidr_block" {}
variable "connectivity_tester_subnet_cidr_block" {}
variable "haproxy_subnet_cidr_block" {}
variable "az" {}
variable "name_prefix" {}


locals {
  name_prefix = "${var.name_prefix}peering-"
}

resource "aws_vpc" "peeringvpc" {
  cidr_block = "${var.cidr_block}"

  tags {
    Name = "${local.name_prefix}vpc"
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
