output "public_iP" {
  value = aws_instance.terraform-ec2.public_ip
}
output "private_ip" {
  value = aws_instance.terraform-ec2.private_ip
}

output "instance_id" {
  value = aws_instance.terraform-ec2.id
}
