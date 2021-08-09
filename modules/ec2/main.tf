provider "aws" {
  region = var.region
}


#ec2
resource "aws_instance" "terraform-ec2" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  key_name               = "serverless-key-pair"
  subnet_id              = var.subnet
  vpc_security_group_ids = ["${var.security_group_id}"]
  tags = {
    Name = "terraform-ec2"
  }
}

