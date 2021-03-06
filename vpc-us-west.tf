resource "aws_vpc" "second-vpc" {
    provider = "aws.usw"
    cidr_block = "10.2.0.0/16"
    enable_dns_hostnames = true

    tags = {
        Name = "tfe-module-demo-usw"
    }
}

resource "aws_internet_gateway" "igw-usw" {
    provider = "aws.usw"
    vpc_id = "${aws_vpc.second-vpc.id}"
}

resource "aws_subnet" "public-subnet-usw" {
    provider = "aws.usw"
    vpc_id = "${aws_vpc.second-vpc.id}"
    cidr_block = "10.2.1.0/24"
    availability_zone = "us-west-2a"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "private-subnet-usw" {
    provider = "aws.usw"
    vpc_id = "${aws_vpc.second-vpc.id}"
    cidr_block = "10.2.2.0/24"
    availability_zone = "us-west-2b"
}

resource "aws_route" "public-routes-usw" {
    provider = "aws.usw"
    route_table_id = "${aws_vpc.second-vpc.default_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-usw.id}"
}

resource "aws_eip" "us-west-nat-ip" {
    provider = "aws.usw"
    vpc = true
}

resource "aws_nat_gateway" "us-west-natgw" {
    provider = "aws.usw"
    allocation_id = "${aws_eip.us-west-nat-ip.id}"
    subnet_id = "${aws_subnet.public-subnet-usw.id}"
    depends_on = ["aws_internet_gateway.igw-usw","aws_subnet.public-subnet-usw"]
}

resource "aws_route_table" "us-west-natgw-route" {
    provider = "aws.usw"
    vpc_id = "${aws_vpc.second-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.us-west-natgw.id}"
    }

    tags {
        Name = "us-west-natgw"
    }
}

resource "aws_route_table_association" "us-west-route-out" {
    provider = "aws.usw"
    subnet_id = "${aws_subnet.private-subnet-usw.id}"
    route_table_id = "${aws_route_table.us-west-natgw-route.id}"
}
