provider "aws" {
  region = "us-east-2"
}

#creating a target group
resource "aws_lb_target_group" "terraform-tg" {
  name     = "terraform-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval           = 15
    path               = "/"
    protocol           = "HTTP"
    timeout            = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


#creating a;b

resource "aws_lb" "terraform-alb" {
  name               = "terraform-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.alb_sg}"]
  subnets            = ["${var.subnet1}","${var.subnet2}"]

  tags = {
    Environment = "production"
  }
}

#attaching the target with alb
resource "aws_lb_target_group_attachment" "tg-ec-register" {
  target_group_arn = aws_lb_target_group.terraform-tg.arn
  target_id        = var.instance_id
  port             = 80
}

#creating listners for alb
resource "aws_lb_listener" "listener-1" {
  load_balancer_arn = aws_lb.terraform-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terraform-tg.arn
  }
}





