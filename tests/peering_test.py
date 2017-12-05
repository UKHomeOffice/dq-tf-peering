# pylint: disable=missing-docstring, line-too-long, protected-access
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

            module "peering" {
              source = "./mymodule"

              providers = {
                aws = "aws"
              }

              cidr_block                            = "10.3.0.0/16"
              connectivity_tester_subnet_cidr_block = "10.3.0.0/24"
              haproxy_subnet_cidr_block             = "10.3.2.0/24"
              opssubnet_cidr_block                  = "10.2.0.0/24"
              acpcicd_vpc_subnet_cidr_block         = "10.7.0.0/24"
              acpops_vpc_subnet_cidr_block          = "10.6.0.0/24"
              acpprod_vpc_subnet_cidr_block         = "10.5.0.0/24"
              acpvpn_vpc_subnet_cidr_block          = "10.4.0.0/24"
              data_ingest_cidr_block                = "10.1.6.0/24"
              data_pipe_apps_cidr_block             = "10.1.8.0/24"
              data_feeds_cidr_block                 = "10.1.4.0/24"
              public_subnet_cidr_block              = "10.1.0.0/24"
              dgdb_apps_cidr_block                  = "10.1.2.0/24"
              mdm_apps_cidr_block                   = "10.1.10.0/24"
              int_dashboard_cidr_block              = "10.1.12.0/24"
              ext_dashboard_cidr_block              = "10.1.14.0/24"
              az                                    = "eu-west-2a"
              name_prefix                           = "dq-"
            }
        """
        self.result = Runner(self.snippet).result

    def test_root_destroy(self):
        self.assertEqual(self.result["destroy"], False)

    def test_vpc_cidr_block(self):
        self.assertEqual(self.result['peering']["aws_vpc.peeringvpc"]["cidr_block"], "10.3.0.0/16")

    def test_peering_connectivity_tester_subnet_cidr_block(self):
        self.assertEqual(self.result['peering']["aws_subnet.connectivity_tester_subnet"]["cidr_block"], "10.3.0.0/24")

    def test_peering_haproxy_subnet_cidr_block(self):
        self.assertEqual(self.result['peering']["aws_subnet.haproxy_subnet"]["cidr_block"], "10.3.2.0/24")

    def test_az_connectivity_tester_subnet(self):
        self.assertEqual(self.result['peering']["aws_subnet.connectivity_tester_subnet"]["availability_zone"], "eu-west-2a")

    def test_az_haproxy_subnet(self):
        self.assertEqual(self.result['peering']["aws_subnet.haproxy_subnet"]["availability_zone"], "eu-west-2a")

    def test_name_prefix_peeringvpc(self):
        self.assertEqual(self.result['peering']["aws_vpc.peeringvpc"]["tags.Name"], "dq-peering-vpc")

    def test_name_prefix_peering_route_table(self):
        self.assertEqual(self.result['peering']["aws_route_table.peering_route_table"]["tags.Name"], "dq-peering-route-table")

    def test_name_prefix_connectivity_tester(self):
        self.assertEqual(self.result['peering']["aws_instance.connectivity_tester"]["tags.Name"], "dq-peering-ec2-linux")

    def test_name_prefix_connectivity_tester(self):
        self.assertEqual(self.result['peering']["aws_security_group.connectivity_tester"]["tags.Name"], "dq-peering-connectivity-sg")

if __name__ == '__main__':
    unittest.main()
