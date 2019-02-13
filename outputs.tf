output "vpc-us-east" {
  value = "${aws_vpc.primary-vpc.id}"
}

output "vpc-us-west" {
  value = "${aws_vpc.second-vpc.id}"
}

output "vpc-eu-west" {
  value = "${aws_vpc.third-vpc.id}"
}

output "us-east-public-subnet" {
    value = "${aws_subnet.public-subnet-use.id}"
}

output "us-east-private-subnet" {
    value = "${aws_subnet.private-subnet-use.id}"
}

output "us-west-public-subnet" {
    value = "${aws_subnet.public-subnet-usw.id}"
}

output "us-west-private-subnet" {
    value = "${aws_subnet.private-subnet-usw.id}"
}

output "eu-west-public-subnet" {
    value = "${aws_subnet.public-subnet-euw.id}"
}

output "eu-west-private-subnet" {
    value = "${aws_subnet.private-subnet-euw.id}"
}
