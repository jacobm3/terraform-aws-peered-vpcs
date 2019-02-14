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

resource "aws_eip" "eu-west-nat-ip" {
    vpc = true
}

resource "aws_nat_gateway" "eu-west-natgw" {
    allocation_id = "${aws_eip.eu-west-nat-ip.id}"
    subnet_id = "${aws_subnet.public-subnet-euw.id}"
    depends_on = ["aws_internet_gateway.igw-euw","aws_subnet.public-subnet-euw"]
}

resource "aws_route_table" "eu-west-natgw-route" {
    vpc_id = "${aws_vpc.primary-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.eu-west-natgw.id}"
    }

    tags {
        Name = "eu-west-natgw"
    }
}

resource "aws_route_table_association" "eu-west-route-out" {
    subnet_id = "${aws_subnet.private-subnet-euw.id}"
    route_table_id = "${aws_route_table.eu-west-natgw-route.id}"
}
