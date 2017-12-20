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

            variable "SGCIDRs" {
              type = "list"
              default = ["1.1.0.0/24", "1.1.0.0/24", "1.1.0.0/24", "1.1.0.0/24"]
            }


            module "peering" {
              source = "./mymodule"

              providers = {
                aws = "aws"
              }


              cidr_block                            = "1.1.0.0/16"
              connectivity_tester_subnet_cidr_block = "1.1.0.0/24"
              haproxy_subnet_cidr_block             = "1.1.0.0/24"
              public_subnet_cidr_block              = "1.1.0.0/24"
              SGCIDRs                               = "${var.SGCIDRs}"
              peering_connectivity_tester_ip        = "1.1.1.1"
              az                                    = "eu-west-2a"
              name_prefix                           = "dq-"
              prod_tester_ip                        = "10.5.1.10"
              ops_tester_ip                         = "10.6.1.10"
              cicd_tester_ip                        = "10.7.1.10"
              ops_bastion_win_ip                    = "10.2.0.12"
              ops_bastion_linux_ip                  = "10.2.0.11"
              ops_ssh_port                          = "22"
              ops_rdp_port                          = "3389"

              vpc_peering_connection_ids            = {
                peering_and_apps = "1234"
                peering_and_ops = "1234"
                peering_and_acpprod = "1234"
                peering_and_acpops = "1234"
                peering_and_acpcicd = "1234"
              }
              route_table_cidr_blocks               = {
                ops_cidr = "1234"
                apps_cidr = "1234"
                acp_prod = "1234"
                acp_ops = "1234"
                acp_cicd = "1234"
              }
            }
        """
        self.result = Runner(self.snippet).result

    def test_root_destroy(self):
        self.assertEqual(self.result["destroy"], False)

    def test_vpc_cidr_block(self):
        self.assertEqual(self.result['peering']["aws_vpc.peeringvpc"]["cidr_block"], "1.1.0.0/16")

    def test_peering_tester_cidr_block(self):
        self.assertEqual(self.result['peering']["aws_subnet.connectivity_tester_subnet"]["cidr_block"], "1.1.0.0/24")

    def test_peering_haproxy_cidr_block(self):
        self.assertEqual(self.result['peering']["aws_subnet.haproxy_subnet"]["cidr_block"], "1.1.0.0/24")

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
