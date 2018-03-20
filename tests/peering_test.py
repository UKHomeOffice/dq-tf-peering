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
              public_subnet_cidr_block              = "1.1.0.0/24"
              SGCIDRs                               = "${var.SGCIDRs}"
              haproxy_private_ip                    = "1.1.1.1"
              s3_bucket_name                        = "abcd"
              s3_bucket_acl                         = "private"
              log_archive_s3_bucket                 = "abcd"
              az                                    = "eu-west-2a"
              naming_suffix                         = "preprod-dq"

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

    def test_name_suffix_peeringvpc(self):
        self.assertEqual(self.result['peering']["aws_vpc.peeringvpc"]["tags.Name"], "vpc-peering-preprod-dq")

    def test_name_peering_route_table(self):
        self.assertEqual(self.result['peering']["aws_route_table.peering_route_table"]["tags.Name"], "route-table-peering-preprod-dq")


if __name__ == '__main__':
    unittest.main()
