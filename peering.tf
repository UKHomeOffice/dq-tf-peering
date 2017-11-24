/*********************************
* Setup VPC Peering
**********************************/

/**
 * Intra AWS account VPC peering connections.
 *
 * Establishes a relationship resource between the "peeringvpc" and "prodvpc" VPC.
 * Establishes a relationship resource between the "peeringvpc" and "opsvpc" VPC.
 */
 resource "aws_vpc_peering_connection" "peeringvpc2prodvpc" {
   vpc_id = "${aws_vpc.peeringvpc.id}"
   peer_vpc_id = "${var.prodvpc_vpc_id}"
   peer_owner_id = "${data.aws_caller_identity.current.account_id}"
   auto_accept = true
   tags {
     Name = "Peering VPC and Apps VPC"
   }
 }

 resource "aws_vpc_peering_connection" "peering2opsvpc" {
   vpc_id = "${aws_vpc.peeringvpc.id}"
   peer_vpc_id = "${var.opsvpc_vpc_id}"
   peer_owner_id = "${data.aws_caller_identity.current.account_id}"
   auto_accept = true
   tags {
     Name = "Peering VPC and Ops VPC"
   }
 }


/*********************************
* Inter AWS account VPC peering connections.
**********************************/

  # Requester's side of the connection.
  resource "aws_vpc_peering_connection" "peeringvpc2acpprodvpc" {
    vpc_id        = "${aws_vpc.peeringvpc.id}"
    peer_vpc_id   = "${var.acpprodvpc_vpc_id}"
    peer_owner_id = "${var.acpprodvpc_vpc_owner_id}"
    auto_accept   = false

    tags {
        Side = "Requester"
      }
      tags {
      Name = "Peering VPC to ACP Prod VPC"
    }
  }

  # Accepter's side of the connection.
  resource "aws_vpc_peering_connection_accepter" "acpprodvpc2peeringvpc" {
    provider                  = "aws.peer"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peeringvpc2acpprodvpc.id}"
    auto_accept               = true

    tags {
      Side = "Accepter"
    }
    tags {
      Name = "ACP Prod VPC to Peering VPC"
    }
  }

  # Requester's side of the connection.
  resource "aws_vpc_peering_connection" "peeringvpc2acpcicdvpc" {
    vpc_id        = "${aws_vpc.peeringvpc.id}"
    peer_vpc_id   = "${var.acpcicdvpc_vpc_id}"
    peer_owner_id = "${var.acpcicdvpc_vpc_owner_id}"
    auto_accept   = false

    tags {
      Side = "Requester"
    }
    tags {
      Name = "Peering VPC to ACP CI/CD VPC"
    }
  }

  # Accepter's side of the connection.
  resource "aws_vpc_peering_connection_accepter" "acpcicdvpc2peeringvpc" {
    provider                  = "aws.peer"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peeringvpc2acpcicdvpc.id}"
    auto_accept               = true

    tags {
      Side = "Accepter"
    }
    tags {
      Name = "ACP CI/CD VPC to Peering VPC"
    }
  }

  # Requester's side of the connection.
  resource "aws_vpc_peering_connection" "peeringvpc2acpopsvpc" {
    vpc_id        = "${aws_vpc.peeringvpc.id}"
    peer_vpc_id   = "${var.acpopsvpc_vpc_id}"
    peer_owner_id = "${var.acpopsvpc_vpc_owner_id}"
    auto_accept   = false

    tags {
      Side = "Requester"
    }
    tags {
      Name = "Peering VPC to ACP OPS VPC"
    }
  }

  # Accepter's side of the connection.
  resource "aws_vpc_peering_connection_accepter" "acpopsvpc2peeringvpc" {
    provider                  = "aws.peer"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peeringvpc2acpopsvpc.id}"
    auto_accept               = true

    tags {
      Side = "Accepter"
    }
    tags {
      Name = "ACP OPS VPC to Peering VPC"
    }
  }


/*********************************
* Create route table for VPC Peering resources
**********************************/

# Route table for HAProxy Subnet
  resource "aws_route_table" "VPCPeeringRouteTableHAProxy" {
    vpc_id = "${aws_vpc.peeringvpc.id}"

    route {
    cidr_block = "${var.opsvpc}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peering2opsvpc.id}"
   }

    route {
    cidr_block = "${var.prodvpc}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peeringvpc2prodvpc.id}"
   }

    route {
    cidr_block = "${var.acpprodvpc}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peeringvpc2acpprodvpc.id}"
   }

    route {
    cidr_block = "${var.acpcicdvpc}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peeringvpc2acpcicdvpc.id}"
   }

    route {
    cidr_block = "${var.acpopsvpc}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peeringvpc2acpopsvpc.id}"
   }
  tags {
  Name = "VPCPeeringRouteTableHAProxy"
  }
}

# Route table for Connectivity Tester Subnet
  resource "aws_route_table" "VPCPeeringRouteTableConTest" {
    vpc_id = "${aws_vpc.peeringvpc.id}"

    route {
    cidr_block = "${var.opsvpc}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peering2opsvpc.id}"
   }

    route {
    cidr_block = "${var.prodvpc}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peeringvpc2prodvpc.id}"
   }

    route {
    cidr_block = "${var.acpprodvpc}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peeringvpc2acpprodvpc.id}"
   }

    route {
    cidr_block = "${var.acpcicdvpc}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peeringvpc2acpcicdvpc.id}"
   }

    route {
    cidr_block = "${var.acpopsvpc}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peeringvpc2acpopsvpc.id}"
   }
  tags {
  Name = "VPCPeeringRouteTableConTest"
  }
}
