provider "aws" {
  region = "us-east-2"
}

#vpc
resource "aws_vpc" "terraform-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terraform-vpc"
  }
}

#internet gateway
resource "aws_internet_gateway" "terraform-igw" {
  vpc_id = aws_vpc.terraform-vpc.id

  tags = {
    Name = "terrraform-igw"
  }
}


#public route table
resource "aws_route_table" "terraform-public-rt" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-igw.id
  }

  tags = {
    Name = "terraform-public-rt"
  }
}

#public subnet-1
resource "aws_subnet" "terraform-subnet" {
  vpc_id                  = aws_vpc.terraform-vpc.id
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-subnet"
  }
}

#public subnet-2
resource "aws_subnet" "terraform-subnet-2" {
  vpc_id                  = aws_vpc.terraform-vpc.id
  cidr_block              = "10.0.20.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-2a"  
  
  tags = {
    Name = "terraform-subnet"
  }
}

#attaching route table to subnet-1
resource "aws_route_table_association" "RouteTable-subnet-association" {
  subnet_id      = aws_subnet.terraform-subnet.id
  route_table_id = aws_route_table.terraform-public-rt.id
}

#attaching route table to subnet-2
resource "aws_route_table_association" "RouteTable-subnet-association-2" {
  subnet_id      = aws_subnet.terraform-subnet-2.id
  route_table_id = aws_route_table.terraform-public-rt.id
}

#security group for ec2
resource "aws_security_group" "terraform-sg-1" {
  name        = "ssh and http"
  description = "Allow port 80 and 22 inbound traffic"
  vpc_id      = aws_vpc.terraform-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.212.214.0/24"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "terraform security group"
  }
}

#security group for alb
resource "aws_security_group" "terraform-alb-sg" {
  name        = "http"
  description = "Allow port 80"
  vpc_id      = aws_vpc.terraform-vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "terraform alb sg"
  }
}


