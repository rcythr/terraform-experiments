
###############################################################################
## Create the VPC and Subnets
###############################################################################

resource "aws_vpc" "experiment" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Experiment"
  }
}

resource "aws_subnet" "dmz" {
  vpc_id                  = aws_vpc.experiment.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Experiment - DMZ"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.experiment.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "Experiment - Private"
  }
}

###############################################################################
## Setup an Internet Gateway & Routes
###############################################################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.experiment.id

  tags = {
    Name = "Experiment"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.experiment.id

  route {
    cidr_block             = "0.0.0.0/0"
    #ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Experiment"
  }
}

resource "aws_route_table_association" "main_dmz" {
  subnet_id      = aws_subnet.dmz.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "main_private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.main.id
}
