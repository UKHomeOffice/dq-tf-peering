module "peering_connectivity_tester" {
  source    = "github.com/ukhomeoffice/connectivity-tester-tf"
  subnet_id = "${aws_subnet.connectivity_tester_subnet.id}"
  user_data = "LISTEN_tcp=0.0.0.0:80 CHECK_ACP_PROD=${var.prod_tester_ip}:${var.acp_port} CHECK_ACP_OPS=${var.ops_tester_ip}:${var.acp_port} CHECK_ACP_CICD=${var.cicd_tester_ip}:${var.acp_port} CHECK_OPS_bastion_win_SSH=${var.ops_bastion_win_ip}:${var.ops_ssh_port} CHECK_OPS_bastion_win_RDP=${var.ops_bastion_win_ip}:${var.ops_rdp_port} CHECK_OPS_bastion_linux_SSH=${var.ops_bastion_linux_ip}:${var.ops_ssh_port} CHECK_OPS_bastion_linux_RDP=${var.ops_bastion_linux_ip}:${var.ops_rdp_port} CHECK_internal_tableau_RDP_TCP=${var.internal_dashboard_instance_ip}:${var.INT_EXT_tableau_RDP_TCP} CHECK_external_tableau_RDP_TCP=${var.external_dashboard_instance_ip}:${var.INT_EXT_tableau_RDP_TCP} CHECK_internal_tableau_HTTPS_TCP=${var.internal_dashboard_instance_ip}:${var.INT_EXT_tableau_HTTPS_TCP} CHECK_external_tableau_HTTPS_TCP=${var.external_dashboard_instance_ip}:${var.INT_EXT_tableau_HTTPS_TCP} CHECK_data_pipeline_RDP_TCP=${var.data_pipeline_web_ip}:${var.data_pipeline_RDP_TCP} CHECK_data_pipeline_RDP_TCP=${var.data_pipeline_postgres_ip}:${var.data_pipeline_RDP_TCP} CHECK_data_pipeline_custom_TCP=${var.data_pipeline_postgres_ip}:${var.data_pipeline_custom_TCP} CHECK_data_ingest_RDP_TCP=${var.data_ingest_web_ip}:${var.data_ingest_RDP_TCP} CHECK_data_ingest_custom_TCP=${var.data_ingest_db_ip}:${var.data_ingest_custom_TCP} CHECK_external_feed_RDP_TCP=${var.data_feeds_web_ip}:${var.external_feed_RDP_TCP} CHECK_external_feed_custom_TCP=${var.data_feeds_postgres_ip}:${var.external_feed_custom_TCP} CHECK_gp_SSH_TCP=${var.greenplum_ip}:${var.greenplum_SSH_TCP}"

  security_groups = ["${aws_security_group.connectivity_tester.id}"]
  private_ip      = "${var.peering_connectivity_tester_ip}"

  tags = {
    Name = "connectivity-tester-${local.naming_suffix}"
  }
}

resource "aws_security_group" "connectivity_tester" {
  vpc_id = "${aws_vpc.peeringvpc.id}"

  tags {
    Name = "sg-connectivity-tester-${local.naming_suffix}"
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "${var.SGCIDRs}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "haproxy_instance" {
  source                    = "github.com/UKHomeOffice/dq-tf-peering-haproxy"
  peeringvpc_id             = "${aws_vpc.peeringvpc.id}"
  route_table_id            = "${aws_route_table.peering_route_table.id}"
  haproxy_subnet_cidr_block = "${var.haproxy_subnet_cidr_block}"
  haproxy_private_ip        = "${var.haproxy_private_ip}"
  s3_bucket_name            = "${var.s3_bucket_name}"
  s3_bucket_acl             = "${var.s3_bucket_acl}"
  log_archive_s3_bucket     = "${var.log_archive_s3_bucket}"
  SGCIDRs                   = ["${var.SGCIDRs}"]
  naming_suffix             = "${local.naming_suffix}"
}
