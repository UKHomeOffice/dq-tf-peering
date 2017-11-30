resource "aws_vpc_endpoint" "configs3endpoint" {
  vpc_id       = "${aws_vpc.peeringvpc.id}"
  service_name = "com.amazonaws.eu-west-2.s3"
}

resource "aws_vpc_endpoint" "logss3endpoint" {
  vpc_id       = "${aws_vpc.peeringvpc.id}"
  service_name = "com.amazonaws.eu-west-2.s3"
}
