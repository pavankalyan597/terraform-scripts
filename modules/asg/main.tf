provider "aws" {
  region = "us-east-2"
}


#creating a lauch configuration for asg
resource "aws_launch_configuration" "terraform-lc" {
  name            = "terraform-lc"
  image_id        = "ami-0b9064170e32bde34"
  instance_type   = "t2.micro"
  security_groups = ["${var.sg_id}"]
  key_name        = "serverless-key-pair"
  user_data       = <<-EOF
		#! /bin/bash
                sudo apt-get update
		sudo apt-get install -y apache2
		sudo systemctl start apache2
		sudo systemctl enable apache2
		echo "<h1>Deployed via Terraform</h1>" > /var/www/html/index.html
	        EOF
}


#auto scaling group
resource "aws_autoscaling_group" "terraform-asg" {
  name                      = "terraform-asg"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  launch_configuration      = aws_launch_configuration.terraform-lc.name
  vpc_zone_identifier       = ["${var.subnet1}", "${var.subnet2}"]
  
  #all ec2 created by asg will automatically added to v=below target group
  target_group_arns         = toset(["${var.target_1_arn}"])
}

#creating a target scaling policy
resource "aws_autoscaling_policy" "scaling-policy" {
  name                   = "target-policy"
  autoscaling_group_name = aws_autoscaling_group.terraform-asg.name
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }
}

