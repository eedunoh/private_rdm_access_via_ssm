terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# Configure the AWS Provider
provider "aws" {
  region = var.region
}


# We create a new VPC
resource  "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    name = var.vpc_name
  }
}


# We create two public subnets for two availability zones in our region (within the same VPC)

resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-north-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_1"
  }
}


resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-north-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_2"
  }
}


# We create two private subnets for two availability zones in our region (within the same VPC)

resource "aws_subnet" "private_subnet_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-north-1a"
  map_public_ip_on_launch = false

  tags = {
    name = "private_subnet_1"
  }
}


resource "aws_subnet" "private_subnet_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-north-1b"
  map_public_ip_on_launch = false

  tags = {
    name = "private_subnet_2"
  }
}



# Create an internet gateway for the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    name = "new_internet_gateway"
  }
}



# Create a route table for the public subnet
resource "aws_route_table" "public_route_table1" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
    }

  tags = {
    name = "public_route_table1"
  }
}


resource "aws_route_table" "public_route_table2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
    }

  tags = {
    name = "public_route_table2"
  }
}



# Create two route tables for the private subnet and to each one, add a nat gateway.

resource "aws_route_table" "private_route_table1" {
  vpc_id = aws_vpc.main.id

  # Allow only local VPC traffic (default behavior)
  route {
    cidr_block = aws_vpc.main.cidr_block
    gateway_id = "local"
  }

  tags = {
    name = "private_route_table1"
  }

}



resource "aws_route_table" "private_route_table2" {
  vpc_id = aws_vpc.main.id

  # Allow only local VPC traffic (default behavior)
  route {
    cidr_block = aws_vpc.main.cidr_block
    gateway_id = "local"
  }

  tags = {
    name = "private_route_table2"
  }

}



# Associate the public route table to the 2 public subnets in the two availability zones

resource "aws_route_table_association" "public_assoc1" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table1.id
}


resource "aws_route_table_association" "public_assoc2" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table2.id
}



# Associate the two private route tables to the 2 private subnets in the two availability zones

resource "aws_route_table_association" "private_assoc1" {
  subnet_id = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table1.id
}


resource "aws_route_table_association" "private_assoc2" {
  subnet_id = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table2.id
}



resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "private-db-subnet-group"
  description = "Subnet group for RDS in private subnets"

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
    ]

  tags = {
    Name = "private-db-subnet-group"
  }
}




# Outputs

output "main_vpc_id" {
  value = aws_vpc.main.id
}


output "public_subnet1_id" {
  value = aws_subnet.public_subnet_1.id
}

output "public_subnet2_id" {
  value = aws_subnet.public_subnet_2.id
}

output "private_subnet1_ids" {
  value = aws_subnet.private_subnet_1.id
}

output "private_subnet2_ids" {
  value = aws_subnet.private_subnet_2.id
}

output "db_subnet_group_name" {
    value = aws_db_subnet_group.db_subnet_group.name
}