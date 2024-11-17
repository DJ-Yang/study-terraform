resource "aws_vpc" "main" {
	cidr_block	= "10.0.0.0/16"

	tags = {
		Name = "terraform-101"
	}
}

resource "aws_subnet" "first_subnet" {
	vpc_id	= aws_vpc.main.id
	cidr_block = "10.0.1.0/24"

	availability_zone = "ap-northeast-2a"

	tags = {
		Name = "101subnet-1"
	}
}

resource "aws_subnet" "second_subnet" {
	vpc_id	= aws_vpc.main.id
	cidr_block = "10.0.2.0/24"

	availability_zone = "ap-northeast-2b"

	tags = {
		Name = "101subnet-2"
	}
}

resource "aws_internet_gateway" "igw" {
	vpc_id = aws_vpc.main.id

	tags = {
		Name = "main"
	}
}

resource "aws_eip" "nat_1" {
	domain = "vpc"	

	lifecycle {
		create_before_destroy = true
	}
}

resource "aws_nat_gateway" "nat_gateway_1" {
	allocation_id = aws_eip.nat_1.id

	subnet_id = aws_subnet.first_subnet.id

	tags = {
		Name = "NAT-GW-1"
	}
}

resource "aws_route_table" "public_route" {
	vpc_id = aws_vpc.main.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw.id
	}

	tags = {
		Name = "public_route_table"
	}
}

resource "aws_route_table" "private_route" {
	vpc_id = aws_vpc.main.id

	tags = {
		Name = "private_route_table"
	}
}

resource "aws_route_table_association" "public_route_table_association" {
	subnet_id = aws_subnet.first_subnet.id
	route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "private_route_table_association" {
	subnet_id = aws_subnet.second_subnet.id
	route_table_id = aws_route_table.private_route.id
}

resource "aws_route" "private_nat" {
	route_table_id 	= aws_route_table.private_route.id
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id	= aws_nat_gateway.nat_gateway_1.id
}
