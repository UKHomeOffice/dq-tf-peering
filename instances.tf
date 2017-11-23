/*********************************
* Create EC2 instance
**********************************/

# Instance in PeeringVPC
resource "aws_instance" "HAProxyInstance" {
 ami           = "${var.haproxy_ami_id}"
 instance_type = "${var.haproxy_instance_class}"
 key_name = "${var.haproxy_key}"
 subnet_id = "${aws_subnet.HAProxyPrivSubnet.id}"
 vpc_security_group_ids = ["${aws_security_group.HAProxySG.id}"]
 associate_public_ip_address = false
 iam_instance_profile = "${aws_iam_instance_profile.HAProxyInstance.name}"

 tags {
   Name = "HAProxy"
 }
}

 # Instance in PeeringVPC
 resource "aws_instance" "ConnectivityTester" {
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_class}"
  key_name = "${var.key}"
  subnet_id = "${aws_subnet.ConnectivityTesterPrivSubnet.id}"
  vpc_security_group_ids = ["${aws_security_group.ConnectivityTesterSG.id}"]
  associate_public_ip_address = false

  tags {
    Name = "ConnectivityTester"
  }
}

  /*********************************
   * Security group.
  **********************************/
  resource "aws_security_group" "HAProxySG" {
    description = "Default security group for all HAProxy instances"
    vpc_id      = "${aws_vpc.peeringvpc.id}"
    tags {
      Name = "HAProxySG"
    }

    ingress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  resource "aws_security_group" "ConnectivityTesterSG" {
    description = "Default security group for all Connectivity Tester instances"
    vpc_id      = "${aws_vpc.peeringvpc.id}"
    tags {
      Name = "ConnectivityTesterSG"
    }

    ingress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
