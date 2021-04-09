/* Create VPC */
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  vpc        = true
  count      = "${length(var.public_subnets_cidr)}"
  depends_on = [aws_internet_gateway.ig]
}

/* NAT */
resource "aws_nat_gateway" "nat" {
  count         = "${length(var.public_subnets_cidr)}"
  allocation_id = "${element(aws_eip.nat_eip.*.id, count.index)}" # aws_eip.nat_eip.id
  subnet_id     = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  depends_on    = [aws_internet_gateway.ig]
  tags = {
    Name        = "nat"
    Environment = var.environment
  }
}

/* Create Public Subnet */
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = "${length(var.public_subnets_cidr)}"
  cidr_block              = "${element(var.public_subnets_cidr, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.environment}-public-subnet"
    Environment = var.environment
  }
}

/* Create Private Subnet */
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = "${length(var.private_subnets_cidr)}"
  cidr_block              = "${element(var.private_subnets_cidr, count.index)}" #var.private_subnets_cidr
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.environment}-private-subnet"
    Environment = var.environment
  }
}

/* Routing Table for Private Subnet */
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  count         = "${length(var.private_subnets_cidr)}"
  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = var.environment
  }
}

/* Routing Table for Public Subnet */
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  count         = "${length(var.public_subnets_cidr)}"
  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = var.environment
  }
}

resource "aws_route" "public_internet_gateway" {
  count                  = "${length(var.public_subnets_cidr)}"
  route_table_id         = "${element(aws_route_table.public.*.id, count.index)}" #"${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.ig.id}"
}

resource "aws_route" "private_nat_gateway" {
  count                  = "${length(var.private_subnets_cidr)}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}" #"${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.nat.*.id, count.index)}" # "${aws_nat_gateway.nat.id}"
}

/* Route table associations */
resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"# "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"# "${aws_route_table.private.id}"
}

/* Default Security Group for VPC */
resource "aws_security_group" "default" {
  name        = "${var.environment}-vpc-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]

  # allow ingress
  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["97.102.162.197/32"]
  }

    ingress {
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

    ingress {
    from_port         = 5000
    to_port           = 5000
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }
  
  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
  }
}
