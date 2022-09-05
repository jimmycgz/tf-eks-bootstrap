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
# Subnets myvpc-public
# ---------------------------------------------------

resource "aws_subnet" "public-subnets" {
  count=3
  vpc_id                  = aws_vpc.jmyvpc.id
  cidr_block              = element(var.public_subnets,count.index)
  availability_zone       = element(var.azs,count.index)
  map_public_ip_on_launch = true
  tags = merge(var.generic_tags, {
    Name = format("%s-public-%d",var.project,count.index)
  })
}

# ---------------------------------------------------
# Subnets myvpc-private
# ---------------------------------------------------

resource "aws_subnet" "private-subnets" {
  count=3
  vpc_id                  = aws_vpc.jmyvpc.id
  cidr_block              = element(var.private_subnets,count.index)
  availability_zone       = element(var.azs,count.index)
  map_public_ip_on_launch = false
  tags = merge(var.generic_tags, {
    Name = format("%s-private-%d",var.project, count.index)
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
  subnet_id     = aws_subnet.public-subnets[2].id

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
# Route table Association public subnets
# ---------------------------------------------------

resource "aws_route_table_association" "public" {
  count=3
  subnet_id      = aws_subnet.public-subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

# ---------------------------------------------------
# Route table Association private subnets
# ---------------------------------------------------

resource "aws_route_table_association" "private" {
  count=3
  subnet_id      = aws_subnet.private-subnets[count.index].id
  route_table_id = aws_route_table.private.id
}