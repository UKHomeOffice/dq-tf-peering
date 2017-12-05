output "peeringaccount_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "peeringvpc_id" {
  value = "${aws_vpc.peeringvpc.id}"
}

output "peeringvpc_cidr_block" {
  value = "${var.cidr_block}"
}

output "connectivity_tester_subnet_id" {
  value = "${aws_subnet.connectivity_tester_subnet.id}"
}

output "connectivity_tester_cidr_block" {
  value = "${var.connectivity_tester_subnet_cidr_block}"
}

output "connectivity_tester_security_group" {
  value = "${aws_security_group.connectivity_tester.id}"
}

output "haproxy_subnet_id" {
  value = "${aws_subnet.haproxy_subnet.id}"
}

output "haproxy_cidr_block" {
  value = "${var.haproxy_subnet_cidr_block}"
}

output "peering_route_table" {
  value = "${aws_route_table.peering_route_table.id}"
}
