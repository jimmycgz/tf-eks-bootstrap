#---------------------------------------------------
# Creating VPC
# ---------------------------------------------------
resource "aws_vpc" "jmyvpc" {

  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.generic_tags, {
    Name = "${var.project}-vpc"
  })

}


# ---------------------------------------------------
# Attaching InterNet Gateway
# ---------------------------------------------------

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.jmyvpc.id
  tags = merge(var.generic_tags, {
    Name = "${var.project}-igw"
  })
}


# ---------------------------------------------------
# Subnet myvpc-public-1
# ---------------------------------------------------

resource "aws_subnet" "public1" {

  vpc_id                  = aws_vpc.jmyvpc.id
  cidr_block              = var.public_subnets[0]
  availability_zone       = var.azs[0]
  map_public_ip_on_launch = true
  tags = merge(var.generic_tags, {
    Name = "${var.project}-public1"
  })
}

# ---------------------------------------------------
# Subent myvpc-public-2
# ---------------------------------------------------

resource "aws_subnet" "public2" {

  vpc_id                  = aws_vpc.jmyvpc.id
  cidr_block              = var.public_subnets[1]
  availability_zone       = var.azs[1]
  map_public_ip_on_launch = true
  tags = merge(var.generic_tags, {
    Name = "${var.project}-public2"
  })
}



# ---------------------------------------------------
# Subnet myvpc-public-3
# ---------------------------------------------------

resource "aws_subnet" "public3" {

  vpc_id                  = aws_vpc.jmyvpc.id
  cidr_block              = var.public_subnets[2]
  availability_zone       = var.azs[2]
  map_public_ip_on_launch = true
  tags = merge(var.generic_tags, {
    Name = "${var.project}-public3"
  })
}

# ---------------------------------------------------
# Subnet myvpc-private-1
# ---------------------------------------------------

resource "aws_subnet" "private1" {

  vpc_id                  = aws_vpc.jmyvpc.id
  cidr_block              = var.private_subnets[0]
  availability_zone       = var.azs[0]
  map_public_ip_on_launch = false
  tags = merge(var.generic_tags, {
    Name = "${var.project}-private1"
  })
}

# ---------------------------------------------------
# Subnet myvpc-private-2
# ---------------------------------------------------

resource "aws_subnet" "private2" {

  vpc_id                  = aws_vpc.jmyvpc.id
  cidr_block              = var.private_subnets[1]
  availability_zone       = var.azs[1]
  map_public_ip_on_launch = false
  tags = merge(var.generic_tags, {
    Name = "${var.project}-private2"
  })
}



# ---------------------------------------------------
# Subnet myvpc-private-3
# ---------------------------------------------------

resource "aws_subnet" "private3" {

  vpc_id                  = aws_vpc.jmyvpc.id
  cidr_block              = var.private_subnets[2]
  availability_zone       = var.azs[2]
  map_public_ip_on_launch = false
  tags = merge(var.generic_tags, {
    Name = "${var.project}-private3"
  })
}


# ---------------------------------------------------
# Creating Elastic Ip
# ---------------------------------------------------

resource "aws_eip" "nat" {
  vpc = true
  tags = merge(var.generic_tags, {
    Name = "${var.project}-eip"
  })
}


# ---------------------------------------------------
# Creating NAT gateway
# ---------------------------------------------------

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public3.id

  tags = merge(var.generic_tags, {
    Name = "${var.project}-nat"
  })
}

# ---------------------------------------------------
# Public Route table
# ---------------------------------------------------

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.jmyvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.generic_tags, {
    Name = "${var.project}-public"
  })
}


# ---------------------------------------------------
# Private Route table
# ---------------------------------------------------

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.jmyvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(var.generic_tags, {
    Name = "${var.project}-private"
  })
}


# ---------------------------------------------------
# Route table Association public1 subnet
# ---------------------------------------------------

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}


# ---------------------------------------------------
# Route table Association public2 subnet
# ---------------------------------------------------

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

# ---------------------------------------------------
# Route table Association public3 subnet
# ---------------------------------------------------

resource "aws_route_table_association" "public3" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.public.id
}


# ---------------------------------------------------
# Route table Association private1 subnet
# ---------------------------------------------------

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}


# ---------------------------------------------------
# Route table Association private2 subnet
# ---------------------------------------------------

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}

# ---------------------------------------------------
# Route table Association private3 subnet
# ---------------------------------------------------

resource "aws_route_table_association" "private3" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.private.id
}