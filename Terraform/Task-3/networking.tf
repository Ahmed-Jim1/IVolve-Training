data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["ivolve-tf"] 
  }
}

locals {
  subnets = [
    {
      name       = "public_subnet"
      cidr_block = "10.0.1.0/24"
      public     = true
    },
    {
      name       = "private_subnet"
      cidr_block = "10.0.2.0/24"
      public     = false
    }
  ]
}

resource "aws_subnet" "subnets" {
  for_each                = { for subnet in local.subnets : subnet.name => subnet }
  vpc_id                  = data.aws_vpc.selected.id
  cidr_block              = each.value.cidr_block
  availability_zone       = var.az
  map_public_ip_on_launch = each.value.public

  tags = {
    Name = each.value.name
    Type = each.value.public ? "Public" : "Private"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = data.aws_vpc.selected.id
}

# Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_vpc.selected.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Public Route Table Association
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.subnets["public_subnet"].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-gateway-eip"
  }
}

# NAT Gateway Resource
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnets["public_subnet"].id

  tags = {
    Name = "imported-nat-gateway"
  }
}

# Route Table for Private Subnet
resource "aws_route_table" "private_rt" {
  vpc_id = data.aws_vpc.selected.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

# Private Route Table Association
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.subnets["private_subnet"].id
  route_table_id = aws_route_table.private_rt.id
}

