output "peeringvpc_id" {
  value = "${aws_vpc.peeringvpc.id}"
}

output "peeringvpc_cidr_block" {
  value = "${var.cidr_block}"
}

output "peering_route_table_id" {
  value = "${aws_route_table.peering_route_table.id}"
}

output "haproxy_subnet_cidr_block" {
  value = "${var.haproxy_subnet_cidr_block}"
}

output "iam_roles" {
  value = "${concat(module.haproxy_instance.iam_roles)}"
}

output "haproxy_private_ip" {
  value = "${var.haproxy_private_ip}"
}

output "haproxy_private_ip2" {
  value = "${var.haproxy_private_ip2}"
}

output "haproxy_config_bucket" {
  value = "${module.haproxy_instance.haproxy_config_bucket}"
}

output "haproxy_config_bucket_key" {
  value = "${module.haproxy_instance.haproxy_config_bucket_key}"
}
