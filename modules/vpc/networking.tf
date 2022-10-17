# The below resource will create VPC

resource "aws_vpc" "main" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "${var.tenancy}"

  tags = {
    Name = "main"
  }
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

# The below resource will create subnet

resource "aws_subnet" "main" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "${var.subnet_cidr}"

  tags = {
    Name = "Public_subnet"
  }
}

resource "aws_subnet" "second" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "${var.private_subnet_cidr}"

  tags = {
    Name = "Private_subnet"
  }
}

output "subnet_id" {
  value = "${aws_subnet.main.id}"
}

output "private_subnet_id" {
  value = "${aws_subnet.second.id}"
}

# The below resource will create Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "main"
  }
}

output "gw_id" {
  value = "${aws_internet_gateway.gw.id}"
}

resource "aws_route_table" "example" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.gw_id}"
  }

  tags = {
    Name = "public_rt"
  }
}

output "rt_id" {
  value = "${aws_route_table.example.id}"
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${var.subnet_id}"
  route_table_id = "${var.rt_id}"
}


# The NAT Gateway resource

resource "aws_eip" "one" {
  vpc                       = true
  associate_with_private_ip = "192.168.0.10"
}

output "allocation_id" {
  value = "${aws_eip.one.allocation_id}"
}

resource "aws_nat_gateway" "example" {
  allocation_id = "${var.allocation_id}"
  subnet_id     = "${var.subnet_id}"

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

output "nat_id" {
  value = "${aws_nat_gateway.example.id}"
}


resource "aws_route_table" "private" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.nat_id}"
  }

  tags = {
    Name = "private_rt"
  }
}

output "rt_prv_id" {
  value = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "b" {
  subnet_id      = "${var.private_subnet_id}"
  route_table_id = "${var.rt_prv_id}"
}