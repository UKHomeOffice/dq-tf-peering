variable "cidr_block" {}
variable "vpc_subnet_cidr_block" {}
variable "az" {}
variable "name_prefix" {}
variable "vpc_subnet2_cidr_block" {}

locals {
  name_prefix = "${var.name_prefix}peering-"
}

resource "aws_vpc" "peeringvpc" {
  cidr_block = "${var.cidr_block}"

  tags {
    Name = "${local.name_prefix}VPC"
  }
}

resource "aws_internet_gateway" "PeeringRouteToInternet" {
  vpc_id = "${aws_vpc.peeringpc.id}"

  tags {
    Name = "${local.name_prefix}IGW"
  }
}

resource "aws_subnet" "PeeringSubnet" {
  vpc_id                  = "${aws_vpc.peeringvpc.id}"
  cidr_block              = "${var.vpc_subnet_cidr_block}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}subnet"
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
