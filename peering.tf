data "aws_caller_identity" "peer-usw" {
    provider = "aws.usw"
}

resource "aws_vpc_peering_connection" "use-usw" {
    provider = "aws"
    vpc_id        = "${aws_vpc.primary-vpc.id}"
    peer_vpc_id   = "${aws_vpc.second-vpc.id}"
    peer_owner_id = "${data.aws_caller_identity.peer-usw.account_id}"
    peer_region   = "us-west-2"
    auto_accept   = false

    tags = {
        Name      = "tfe-module-peer-to-usw"
        Side      = "Requester"
    }  
}

resource "aws_vpc_peering_connection_accepter" "use-usw-a" {
    provider                    = "aws.usw"
    vpc_peering_connection_id   = "${aws_vpc_peering_connection.use-usw.id}"
    auto_accept                 = true

    tags = {
        Side                    = "Accepter"
    }
}

resource "aws_route_table" "peer-route-use-usw-a" {
    provider                        = "aws"
    vpc_id                          = "${aws_vpc.primary-vpc.id}"
    route {
        cidr_block                  = "10.2.0.0/16"
        vpc_peering_connection_id   = "${aws_vpc_peering_connection.use-usw.id}"
    }

    tags {
        Name = "peer-route-use-usw-a"
    }
}

resource "aws_route_table_association" "peer-route-usw-out-a" {
    provider                        = "aws"
    subnet_id                       = "${aws_subnet.private-subnet-use.id}"
    route_table_id                  = "${aws_route_table.peer-route-use-usw-a.id}"
}


resource "aws_route_table" "peer-route-use-usw-b" {
    provider                        = "aws.usw"
    vpc_id                          = "${aws_vpc.second-vpc.id}"
    route {
        cidr_block                  = "10.0.0.0/16"
        vpc_peering_connection_id   = "${aws_vpc_peering_connection_accepter.use-usw-a.id}"
    }

    tags {
        Name = "peer-route-use-usw-b"
    }    
}

resource "aws_route_table_association" "peer-route-usw-out-b" {
    provider                        = "aws.usw"
    subnet_id                       = "${aws_subnet.private-subnet-usw.id}"
    route_table_id                  = "${aws_route_table.peer-route-use-usw-b.id}"
}


///////////////////////////
///////////////////////////
///////////////////////////

data "aws_caller_identity" "peer-euw" {
    provider = "aws.euw"
}

resource "aws_vpc_peering_connection" "use-euw" {
    provider      = "aws"
    vpc_id        = "${aws_vpc.primary-vpc.id}"
    peer_vpc_id   = "${aws_vpc.third-vpc.id}"
    peer_owner_id = "${data.aws_caller_identity.peer-euw.account_id}"
    peer_region   = "eu-west-1"
    auto_accept   = false

    tags = {
        Name      = "tfe-module-peer-to-euw"
        Side      = "Requester"
    }  
}

resource "aws_vpc_peering_connection_accepter" "use-euw-a" {
    provider                    = "aws.euw"
    vpc_peering_connection_id   = "${aws_vpc_peering_connection.use-euw.id}"
    auto_accept                 = true

    tags = {
        Side                    = "Accepter"
    }
}

resource "aws_route" "peer-route-use-euw-a" {
    provider                    = "aws"
    route_table_id              = "${aws_vpc.primary-vpc.default_route_table_id}"
    destination_cidr_block      = "10.4.0.0/16"
    vpc_peering_connection_id   = "${aws_vpc_peering_connection.use-euw.id}"
}

resource "aws_route" "peer-route-use-euw-b" {
    provider                    = "aws.euw"
    route_table_id              = "${aws_vpc.third-vpc.default_route_table_id}"
    destination_cidr_block      = "10.0.0.0/16"
    vpc_peering_connection_id   = "${aws_vpc_peering_connection_accepter.use-euw-a.id}"
}

resource "aws_route_table" "peer-route-use-euw-a" {
    provider                        = "aws"
    vpc_id                          = "${aws_vpc.primary-vpc.id}"
    route {
        cidr_block                  = "10.4.0.0/16"
        vpc_peering_connection_id   = "${aws_vpc_peering_connection.use-euw.id}"
    }

    tags {
        Name = "peer-route-use-euw-a"
    }
}

resource "aws_route_table_association" "peer-route-euw-out-a" {
    provider                        = "aws"
    subnet_id                       = "${aws_subnet.private-subnet-use.id}"
    route_table_id                  = "${aws_route_table.peer-route-use-euw-a.id}"
}


resource "aws_route_table" "peer-route-use-euw-b" {
    provider                        = "aws.euw"
    vpc_id                          = "${aws_vpc.third-vpc.id}"
    route {
        cidr_block                  = "10.0.0.0/16"
        vpc_peering_connection_id   = "${aws_vpc_peering_connection_accepter.use-euw-a.id}"
    }

    tags {
        Name = "peer-route-use-euw-b"
    }    
}

resource "aws_route_table_association" "peer-route-euw-out-b" {
    provider                        = "aws.euw"
    subnet_id                       = "${aws_subnet.private-subnet-euw.id}"
    route_table_id                  = "${aws_route_table.peer-route-use-euw-b.id}"
}
