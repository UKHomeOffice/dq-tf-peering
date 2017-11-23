/*********************************
* Setup VPC Peering
**********************************/

/**
 * Intra AWS account VPC peering connections.
 *
 * Establishes a relationship resource between the "peeringvpc" and "opsvpc" VPC.
 */

 resource "aws_vpc_peering_connection" "peering2opsvpc" {
   vpc_id = "${aws_vpc.peeringvpc.id}"
   peer_vpc_id = "${var.opsvpc_vpc_id}"
   peer_owner_id = "${data.aws_caller_identity.current.account_id}"
   auto_accept = true
   tags {
     Name = "Peering and Ops"
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

  tags {
  Name = "VPCPeeringRouteTableConTest"
  }
}
