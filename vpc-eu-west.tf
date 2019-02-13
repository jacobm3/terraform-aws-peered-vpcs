resource "aws_vpc" "third-vpc" {
    provider               = "aws.euw"
    cidr_block             = "10.4.0.0/16"
    enable_dns_hostnames   = true

    tags = {
        Name = "tfe-module-demo-euw"
    }
}

resource "aws_internet_gateway" "igw-euw" {
    provider   = "aws.euw"
    vpc_id     = "${aws_vpc.third-vpc.id}"
}

resource "aws_subnet" "public-subnet-euw" {
    provider                  = "aws.euw"
    vpc_id                    = "${aws_vpc.third-vpc.id}"
    cidr_block                = "10.4.1.0/24"
    availability_zone         = "eu-west-1a"
    map_public_ip_on_launch   = true
}

resource "aws_subnet" "private-subnet-euw" {
    provider            = "aws.euw"
    vpc_id              = "${aws_vpc.third-vpc.id}"
    cidr_block          = "10.4.2.0/24"
    availability_zone   = "eu-west-1b"
}

resource "aws_route" "public-routes-euw" {
    provider                 = "aws.euw"
    route_table_id           = "${aws_vpc.third-vpc.default_route_table_id}"
    destination_cidr_block   = "0.0.0.0/0"
    gateway_id               = "${aws_internet_gateway.igw-euw.id}"
}
