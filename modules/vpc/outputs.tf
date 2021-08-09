output "vpc_id" {
  value = aws_vpc.terraform-vpc.id
}

output "subnet_id" {
  value = aws_subnet.terraform-subnet.id
}

output "sg_id" {
  value = aws_security_group.terraform-sg-1.id
}

output "alb_sg" {
  value = aws_security_group.terraform-alb-sg.id
}

output "subnet_id_2" {
  value = aws_subnet.terraform-subnet-2.id
}
