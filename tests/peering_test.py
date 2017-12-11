# pylint: disable=missing-docstring, line-too-long, protected-access, E1101, C0202, E0602, W0109
import unittest
from runner import Runner


class TestE2E(unittest.TestCase):
    @classmethod
    def setUpClass(self):
        self.snippet = """

            provider "aws" {
              region = "eu-west-2"
              skip_credentials_validation = true
              skip_get_ec2_platforms = true
            }

            variable "CIDRs" {
              type = "string"
              default = "1.1.1.0/24"
           }

            module "peering" {
              source = "./mymodule"

              providers = {
                aws = "aws"
              }


              cidr_block                            = "1.1.0.0/16"
              connectivity_tester_subnet_cidr_block = "${var.CIDRs}"
              haproxy_subnet_cidr_block             = "${var.CIDRs}"
              opssubnet_cidr_block                  = "${var.CIDRs}"
              acpcicd_vpc_subnet_cidr_block         = "${var.CIDRs}"
              acpops_vpc_subnet_cidr_block          = "${var.CIDRs}"
              acpprod_vpc_subnet_cidr_block         = "${var.CIDRs}"
              acpvpn_vpc_subnet_cidr_block          = "${var.CIDRs}"
              data_ingest_cidr_block                = "${var.CIDRs}"
              data_pipe_apps_cidr_block             = "${var.CIDRs}"
              data_feeds_cidr_block                 = "${var.CIDRs}"
              public_subnet_cidr_block              = "${var.CIDRs}"
              dgdb_apps_cidr_block                  = "${var.CIDRs}"
              mdm_apps_cidr_block                   = "${var.CIDRs}"
              int_dashboard_cidr_block              = "${var.CIDRs}"
              ext_dashboard_cidr_block              = "${var.CIDRs}"
              peering_connectivity_tester_ip        = "1.1.1.1"
              az                                    = "eu-west-2a"
              name_prefix                           = "dq-"
            }
        """
        self.result = Runner(self.snippet).result

    def test_root_destroy(self):
        self.assertEqual(self.result["destroy"], False)

    def test_vpc_cidr_block(self):
        self.assertEqual(self.result['peering']["aws_vpc.peeringvpc"]["cidr_block"], "1.1.0.0/16")

    def test_peering_tester_cidr_block(self):
        self.assertEqual(self.result['peering']["aws_subnet.connectivity_tester_subnet"]["cidr_block"], "1.1.1.0/24")

    def test_peering_haproxy_cidr_block(self):
        self.assertEqual(self.result['peering']["aws_subnet.haproxy_subnet"]["cidr_block"], "1.1.1.0/24")

    def test_az_connectivity_tester(self):
        self.assertEqual(self.result['peering']["aws_subnet.connectivity_tester_subnet"]["availability_zone"], "eu-west-2a")

    def test_az_haproxy_subnet(self):
        self.assertEqual(self.result['peering']["aws_subnet.haproxy_subnet"]["availability_zone"], "eu-west-2a")

    def test_name_prefix_peeringvpc(self):
        self.assertEqual(self.result['peering']["aws_vpc.peeringvpc"]["tags.Name"], "dq-peering-vpc")

    def test_name_peering_route_table(self):
        self.assertEqual(self.result['peering']["aws_route_table.peering_route_table"]["tags.Name"], "dq-peering-route-table")

    def test_name_connectivity_tester(self):
        self.assertEqual(self.result['peering']["aws_security_group.connectivity_tester"]["tags.Name"], "dq-peering-connectivity-sg")

if __name__ == '__main__':
    unittest.main()
