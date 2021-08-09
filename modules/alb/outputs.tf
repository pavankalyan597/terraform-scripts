output "alb_id" {
  value = aws_lb.terraform-alb.id
}

output "tg_id" {
  value = aws_lb_target_group.terraform-tg.id
}

output "target_1_arn" {
  value = aws_lb_target_group.terraform-tg.arn
}
