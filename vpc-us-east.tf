resource "aws_vpc" "primary-vpc" {
    provider = "aws"
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true

    tags = {
        Name = "tfe-module-demo-use"
    }
}

resource "aws_internet_gateway" "igw-use" {
    provider = "aws"
    vpc_id = "${aws_vpc.primary-vpc.id}"
}

resource "aws_subnet" "public-subnet-use" {
    provider = "aws"
    vpc_id = "${aws_vpc.primary-vpc.id}"
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "private-subnet-use" {
    provider = "aws"
    vpc_id = "${aws_vpc.primary-vpc.id}"
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
}

resource "aws_route" "public-routes-use" {
    provider = "aws"
    route_table_id = "${aws_vpc.primary-vpc.default_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-use.id}"
}
