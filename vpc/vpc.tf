resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  
  tags = {
    "Name" = "${var.vpc_name}-igw"
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.vpc.id
  count = var.public_subnet_number
  cidr_block = "${element(var.public_subnet_cidrs, count.index)}"
  availability_zone = "${element(var.region_azs, count.index)}"
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.vpc_name}-public-subnet-${substr(element(var.region_azs, count.index), -1, 1)}"
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.vpc.id
  count = var.private_subnet_number
  cidr_block = "${element(var.private_subnet_cidrs, count.index)}"
  availability_zone = "${element(var.region_azs, count.index)}"
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    "Name" = "${var.vpc_name}-private-subnet-${substr(element(var.region_azs, count.index), -1, 1)}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "${var.vpc_name}-public-route-table"
  }
}

resource "aws_route_table" "private_route_tables" {
  vpc_id = aws_vpc.vpc.id
  # count = "${length(var.region_azs)}"
  count = 1

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = aws_instance.NAT-Instance[count.index].primary_network_interface_id
  }

  tags = {
    "Name" = "${var.vpc_name}-private-route-table-${substr(element(var.region_azs, count.index), -1, 1)}"
  }
}

resource "aws_route_table_association" "public_subnet_route_association" {
  count = var.public_subnet_number
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# resource "aws_route_table_association" "private_subnet_route_associations" {
#   count = var.private_subnet_number
#   subnet_id = aws_subnet.private_subnets[count.index].id
# }