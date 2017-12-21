provider "aws" {}

locals {
  name_prefix = "${var.name_prefix}peering-"
}

resource "aws_vpc" "peeringvpc" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = true

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

resource "aws_subnet" "peering_public_subnet" {
  vpc_id                  = "${aws_vpc.peeringvpc.id}"
  cidr_block              = "${var.public_subnet_cidr_block}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}public-subnet"
  }
}

resource "aws_internet_gateway" "peering_igw" {
  vpc_id = "${aws_vpc.peeringvpc.id}"

  tags {
    Name = "${local.name_prefix}public-igw"
  }
}

resource "aws_eip" "peering_eip" {
  vpc = true
}

resource "aws_nat_gateway" "peering_nat_gw" {
  allocation_id = "${aws_eip.peering_eip.id}"
  subnet_id     = "${aws_subnet.peering_public_subnet.id}"
}

resource "aws_route_table" "peering_route_table" {
  vpc_id = "${aws_vpc.peeringvpc.id}"

  route {
    cidr_block                = "${var.route_table_cidr_blocks["ops_cidr"]}"
    vpc_peering_connection_id = "${var.vpc_peering_connection_ids["peering_and_ops"]}"
  }

  route {
    cidr_block                = "${var.route_table_cidr_blocks["apps_cidr"]}"
    vpc_peering_connection_id = "${var.vpc_peering_connection_ids["peering_and_apps"]}"
  }

  route {
    cidr_block                = "${var.route_table_cidr_blocks["acp_prod"]}"
    vpc_peering_connection_id = "${var.vpc_peering_connection_ids["peering_and_acpprod"]}"
  }

  route {
    cidr_block                = "${var.route_table_cidr_blocks["acp_ops"]}"
    vpc_peering_connection_id = "${var.vpc_peering_connection_ids["peering_and_acpops"]}"
  }

  route {
    cidr_block                = "${var.route_table_cidr_blocks["acp_cicd"]}"
    vpc_peering_connection_id = "${var.vpc_peering_connection_ids["peering_and_acpcicd"]}"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.peering_nat_gw.id}"
  }

  tags {
    Name = "${local.name_prefix}route-table"
  }
}

resource "aws_route_table" "peering_public_table" {
  vpc_id = "${aws_vpc.peeringvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.peering_igw.id}"
  }

  tags {
    Name = "${local.name_prefix}public-route-table"
  }
}

resource "aws_route_table_association" "connectivity_tester_subnet" {
  subnet_id      = "${aws_subnet.connectivity_tester_subnet.id}"
  route_table_id = "${aws_route_table.peering_route_table.id}"
}

resource "aws_route_table_association" "peering_public_subnet" {
  subnet_id      = "${aws_subnet.peering_public_subnet.id}"
  route_table_id = "${aws_route_table.peering_public_table.id}"
}
