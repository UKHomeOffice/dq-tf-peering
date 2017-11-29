variable "cidr_block" {}
variable "vpc_subnet1_cidr_block" {}
variable "vpc_subnet2_cidr_block" {}
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

resource "aws_internet_gateway" "PeeringRouteToInternet" {
  vpc_id = "${aws_vpc.peeringvpc.id}"

  tags {
    Name = "${local.name_prefix}igw"
  }
}

resource "aws_subnet" "PeeringSubnet1" {
  vpc_id                  = "${aws_vpc.peeringvpc.id}"
  cidr_block              = "${var.vpc_subnet1_cidr_block}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}subnet1"
  }
}

resource "aws_subnet" "PeeringSubnet2" {
  vpc_id                  = "${aws_vpc.peeringvpc.id}"
  cidr_block              = "${var.vpc_subnet2_cidr_block}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}subnet2"
  }
}
