variable "cidr_block" {}
variable "connectivity_tester_subnet_cidr_block" {}
variable "haproxy_subnet_cidr_block" {}
variable "az" {}
variable "name_prefix" {}
variable "opssubnet_cidr_block" {}
variable "acpcicd_vpc_subnet_cidr_block" {}
variable "acpops_vpc_subnet_cidr_block" {}
variable "acpprod_vpc_subnet_cidr_block" {}
variable "acpvpn_vpc_subnet_cidr_block" {}
variable "data_ingest_cidr_block" {}
variable "data_pipe_apps_cidr_block" {}
variable "data_feeds_cidr_block" {}
variable "public_subnet_cidr_block" {}
variable "dgdb_apps_cidr_block" {}
variable "mdm_apps_cidr_block" {}
variable "int_dashboard_cidr_block" {}
variable "ext_dashboard_cidr_block" {}
variable "peering_connectivity_tester_ip" {}

variable "service" {
  default     = "dq-peering"
  description = "As per naming standards in AWS-DQ-Network-Routing 0.5 document"
}

variable "environment" {
  default     = "preprod"
  description = "As per naming standards in AWS-DQ-Network-Routing 0.5 document"
}

variable "environment_group" {
  default     = "dq-peering"
  description = "As per naming standards in AWS-DQ-Network-Routing 0.5 document"
}
