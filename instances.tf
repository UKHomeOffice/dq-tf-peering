module "haproxy_instance" {
  source                    = "github.com/UKHomeOffice/dq-tf-peering-haproxy"
  peeringvpc_id             = aws_vpc.peeringvpc.id
  route_table_id            = aws_route_table.peering_route_table.id
  haproxy_subnet_cidr_block = var.haproxy_subnet_cidr_block
  haproxy_private_ip        = var.haproxy_private_ip
  haproxy_private_ip2       = var.haproxy_private_ip2
  s3_bucket_name            = var.s3_bucket_name
  s3_bucket_acl             = var.s3_bucket_acl
  log_archive_s3_bucket     = var.log_archive_s3_bucket
  SGCIDRs                   = var.SGCIDRs
  naming_suffix             = local.naming_suffix
}
