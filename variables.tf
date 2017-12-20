variable "cidr_block" {}
variable "connectivity_tester_subnet_cidr_block" {}
variable "haproxy_subnet_cidr_block" {}
variable "public_subnet_cidr_block" {}
variable "peering_connectivity_tester_ip" {}
variable "az" {}
variable "name_prefix" {}

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
