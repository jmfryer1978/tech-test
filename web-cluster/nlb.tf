locals {
  module_tags = {
    Resource = "TechTest"
  }
}

data "aws_subnet_ids" "nlb_subnets" {
  vpc_id = var.vpc_id
}

# Create a Network Load Balancer

resource "aws_lb" "tech_test_lb" {
  name                             = "${var.service}-elb"
  internal                         = false
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true

  subnets = flatten([data.aws_subnet_ids.nlb_subnets.ids])

  tags = local.module_tags
}

resource "aws_lb_target_group" "tech_test_tg" {
  name     = "${var.service}-${var.server_port}"
  port     = var.server_port
  protocol = "TCP"
  vpc_id   = var.vpc_id
  tags     = local.module_tags

  deregistration_delay = "300"
}

resource "aws_lb_listener" "tech_test_listener" {
  load_balancer_arn = aws_lb.tech_test_lb.arn
  port              = var.server_port
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.tech_test_tg.arn
    type             = "forward"
  }

  depends_on = [aws_lb_target_group.tech_test_tg]
}
