output "peeringvpc_id" {
  value = "${aws_vpc.peeringvpc.id}"
}

output "peeringvpc_cidr_block" {
  value = "${var.cidr_block}"
}

output "haproxy_config_bucket_name" {
  value = "${aws_s3_bucket.haproxy_config_bucket.arn}"
}

output "haproxy_log_bucket_name" {
  value = "${aws_s3_bucket.haproxy_log_bucket.arn}"
}

output "peering_route_table_id" {
  value = "${aws_route_table.peering_route_table.id}"
}
