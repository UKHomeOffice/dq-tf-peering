output "peeringvpc_id" {
  value = "${aws_vpc.peeringvpc.id}"
}

output "peeringvpc_cidr_block" {
  value = "${var.cidr_block}"
}

output "configs3endpoint_id" {
  value = "${aws_vpc_endpoint.configs3endpoint.id}"
}

output "logs3endpoint_id" {
  value = "${aws_vpc_endpoint.logss3endpoint.id}"
}
