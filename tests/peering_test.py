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

              cidr_block             = "10.3.0.0/16"
              vpc_subnet1_cidr_block  = "10.3.0.0/24"
              vpc_subnet2_cidr_block = "10.3.1.0/24"
              az                     = "eu-west-2a"
              name_prefix            = "dq-"
            }
        """
        self.result = Runner(self.snippet).result

    def test_root_destroy(self):
        self.assertEqual(self.result["destroy"], False)

    def test_vpc_cidr_block(self):
        self.assertEqual(self.result['peering']["aws_vpc.peeringvpc"]["cidr_block"], "10.3.0.0/16")

    def test_peering_subnet1_cidr_block(self):
        self.assertEqual(self.result['peering']["aws_subnet.PeeringSubnet1"]["cidr_block"], "10.3.0.0/24")

    def test_peering_subnet2_cidr_block(self):
        self.assertEqual(self.result['peering']["aws_subnet.PeeringSubnet2"]["cidr_block"], "10.3.1.0/24")

    def test_az_subnet1(self):
        self.assertEqual(self.result['peering']["aws_subnet.PeeringSubnet1"]["availability_zone"], "eu-west-2a")

    def test_az_subnet2(self):
        self.assertEqual(self.result['peering']["aws_subnet.PeeringSubnet2"]["availability_zone"], "eu-west-2a")

    def test_name_prefix_PeeringRouteToInternet(self):
        self.assertEqual(self.result['peering']["aws_internet_gateway.PeeringRouteToInternet"]["tags.Name"], "dq-peering-igw")

    def test_name_prefix_peeringvpc(self):
        self.assertEqual(self.result['peering']["aws_vpc.peeringvpc"]["tags.Name"], "dq-peering-vpc")

    def test_name_prefix_BastionHostLinux(self):
        self.assertEqual(self.result['peering']["aws_instance.BastionHostLinux"]["tags.Name"], "dq-peering-ec2-linux")

    def test_name_prefix_Bastions(self):
        self.assertEqual(self.result['peering']["aws_security_group.Bastions"]["tags.Name"], "dq-peering-sg")

if __name__ == '__main__':
    unittest.main()
