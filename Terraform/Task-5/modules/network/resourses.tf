# Create a VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my_vpc"
  }
}

locals {
  azs = ["us-east-1a", "us-east-1b"] 
}

# Public Subnets

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                 = aws_vpc.my-vpc.id
  # Using different CIDR blocks for each subnet
  cidr_block             = "10.0.${count.index + 1}.0/24"
  availability_zone      = local.azs[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public-${local.azs[count.index]}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.my-vpc.id
  map_public_ip_on_launch = true
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = local.azs[count.index]
  
  tags = {
    Name = "private-${local.azs[count.index]}"
  }
}

# CREATE AN INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "my-igw"
  }
}

# Create a Route Table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "rt-association1" {
  subnet_id      = aws_subnet.public[0].id
  route_table_id = aws_route_table.public-rt.id
}


resource "aws_route_table_association" "rt-association2" {
  subnet_id      = aws_subnet.public[1].id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "rt-association3" {
  subnet_id      = aws_subnet.private[0].id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "rt-association4" {
  subnet_id      = aws_subnet.private[1].id
  route_table_id = aws_route_table.public-rt.id
}

