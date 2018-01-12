variable "cidr_block" {}
variable "connectivity_tester_subnet_cidr_block" {}
variable "peering_connectivity_tester_ip" {}
variable "public_subnet_cidr_block" {}
variable "s3_bucket_name" {}
variable "s3_bucket_acl" {}
variable "log_archive_s3_bucket" {}
variable "az" {}

variable "naming_suffix" {
  default     = false
  description = "Naming suffix for tags, value passed from dq-tf-apps"
}

variable "haproxy_subnet_cidr_block" {
  default = "10.3.0.0/24"
}

variable "haproxy_private_ip" {
  default = "10.3.0.10"
}

variable "region" {
  default = "eu-west-2"
}

variable "vpc_peering_connection_ids" {
  description = "Map of VPC peering IDs for the Peering route table."
  type        = "map"
}

variable "route_table_cidr_blocks" {
  description = "Map of CIDR blocks for the Peering route table."
  type        = "map"
}

variable "SGCIDRs" {
  description = "Add subnet CIDRs for the Connectivity tester Security Group"
  type        = "list"
  default     = []
}

variable "acp_port" {
  default     = "80"
  description = "Listening port for ACP"
}

variable "prod_tester_ip" {
  default     = "10.5.1.10"
  description = "ACP private IP address"
}

variable "ops_tester_ip" {
  default     = "10.6.1.10"
  description = "ACP private IP address"
}

variable "cicd_tester_ip" {
  default     = "10.7.1.10"
  description = "ACP private IP address"
}

variable "ops_bastion_win_ip" {
  default     = "10.2.0.12"
  description = "Ops Windows Bastion IP address"
}

variable "ops_bastion_linux_ip" {
  default     = "10.2.0.11"
  description = "Ops Linux Bastion IP address"
}

variable "ops_ssh_port" {
  default     = "22"
  description = "SSH port for Ops traffic"
}

variable "ops_rdp_port" {
  default     = "3389"
  description = "RDP port for Ops traffic"
}

variable "INT_EXT_tableau_RDP_TCP" {
  default     = 3389
  description = "RDP TCP connectivty port for external and internal tableau apps"
}

variable "internal_dashboard_instance_ip" {
  default     = "10.1.12.11"
  description = "Mock IP address of EC2 instance for internal tableau apps"
}

variable "external_dashboard_instance_ip" {
  default     = "10.1.14.11"
  description = "Mock IP address of EC2 instance for external tableau apps"
}

variable "INT_EXT_tableau_HTTPS_TCP" {
  default     = 443
  description = "HTTPS TCP connectivty port for external and internal tableau apps"
}

variable "data_pipeline_RDP_TCP" {
  default     = 3389
  description = "RDP TCP connectivty port for data pipeline app"
}

variable "data_pipeline_custom_TCP" {
  default     = 1433
  description = "Custom TCP connectivty port for data pipeline app"
}

variable "data_pipeline_postgres_ip" {
  default     = "10.1.8.11"
  description = "Mock EC2 database instance for data pipeline app"
}

variable "data_pipeline_web_ip" {
  default     = "10.1.8.21"
  description = "Mock EC2 web instance for data pipeline app"
}

variable "data_ingest_RDP_TCP" {
  default     = 3389
  description = "RDP TCP connectivty port for data ingest app"
}

variable "data_ingest_custom_TCP" {
  default     = 5432
  description = "Custom TCP connectivty port for data ingest app"
}

variable "data_ingest_web_ip" {
  default     = "10.1.6.21"
  description = "Mock EC2 web instance for data ingest app"
}

variable "data_ingest_db_ip" {
  default     = "10.1.6.11"
  description = "Mock EC2 database instance for data ingest app"
}

variable "external_feed_RDP_TCP" {
  default     = 3389
  description = "RDP TCP connectivty port for external feed app"
}

variable "external_feed_custom_TCP" {
  default     = 5432
  description = "Custom TCP connectivty port for external feed app"
}

variable "data_feeds_postgres_ip" {
  default     = "10.1.4.11"
  description = "Mock IP address of database EC2 instance for external data feeds app"
}

variable "data_feeds_web_ip" {
  default     = "10.1.4.21"
  description = "Mock IP address of web EC2 instance for external data feeds app"
}

variable "greenplum_SSH_TCP" {
  default     = 22
  description = "SSH TCP connectivty port for greenplum database"
}

variable "greenplum_ip" {
  default     = "10.1.2.11"
  description = "IP address for Greenplum"
}
