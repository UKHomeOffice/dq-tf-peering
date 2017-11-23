/*********************************
 * VPC.
 * Virtual network which will be referred to as "PeeringVPC" in this example.
**********************************/
resource "aws_vpc" "peeringvpc" {
  cidr_block = "${var.peeringvpc}"
  tags {
    Name = "Peering VPC"
  }
}

/*********************************
 * Private Subnets.
 * Availability zone no.1
**********************************/

resource "aws_subnet" "HAProxyPrivSubnet" {
  vpc_id                  = "${aws_vpc.peeringvpc.id}"
  cidr_block              = "${var.HAProxy-cidr-block}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.AZ1}"
  tags {
    Name = "HAProxy Private Subnet"
  }
}

resource "aws_subnet" "ConnectivityTesterPrivSubnet" {
  vpc_id                  = "${aws_vpc.peeringvpc.id}"
  cidr_block              = "${var.connectivity-tester-cidr-block}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.AZ1}"
  tags {
    Name = "Connectivity Tester Private Subnet"
  }
}

/*********************************
* Route Table association
**********************************/

resource "aws_route_table_association" "HAProxyPrivRoute" {
  subnet_id      = "${aws_subnet.HAProxyPrivSubnet.id}"
  route_table_id = "${aws_route_table.VPCPeeringRouteTableHAProxy.id}"
}

resource "aws_route_table_association" "ConnectivityTesterPrivRoute" {
  subnet_id      = "${aws_subnet.ConnectivityTesterPrivSubnet.id}"
  route_table_id = "${aws_route_table.VPCPeeringRouteTableConTest.id}"
}

/*********************************
* Access lists
**********************************/

# Disable default ACL
resource "aws_default_network_acl" "default" {
  default_network_acl_id = "${aws_vpc.peeringvpc.default_network_acl_id}"
  tags {
  Name = "Default VPC ACL"
  }
}

# ACL for HAProxy Subnet
resource "aws_network_acl" "HAProxyACL" {
  vpc_id = "${aws_vpc.peeringvpc.id}"
  subnet_ids = ["${aws_subnet.HAProxyPrivSubnet.id}"]

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags {
    Name = "HAProxy ACL"
    }
  }

# ACL for Connectivity Tester Subnet
resource "aws_network_acl" "ConnectivityTesterACL" {
  vpc_id = "${aws_vpc.peeringvpc.id}"
  subnet_ids = ["${aws_subnet.ConnectivityTesterPrivSubnet.id}"]

  ingress {
    protocol   = "-1"
    rule_no    = 101
    action     = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 201
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
tags {
      Name = "Connectivity Tester ACL"
    }
  }

/*********************************
* Setup S3 VPC endpoint
**********************************/

  resource "aws_vpc_endpoint" "HAProxyS3Endpoint" {
  vpc_id       = "${aws_vpc.peeringvpc.id}"
  service_name = "com.amazonaws.eu-west-2.s3"
  route_table_ids = ["${aws_route_table.VPCPeeringRouteTableHAProxy.id}"]
}
