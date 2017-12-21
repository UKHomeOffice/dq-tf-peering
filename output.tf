output "peeringvpc_id" {
  value = "${aws_vpc.peeringvpc.id}"
}

output "peeringvpc_cidr_block" {
  value = "${var.cidr_block}"
}

output "peering_route_table_id" {
  value = "${aws_route_table.peering_route_table.id}"
}
