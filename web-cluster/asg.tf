# All ASG related Code here 

data "aws_ami" "tech_test_ami" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_availability_zones" "all" {}

resource "aws_launch_configuration" "tech_test_asg_lc" {
  #image_id        = data.aws_ami.tech_test_ami.id
  image_id        = "ami-07a21898d692a2709"
  instance_type   = var.instance_type
  security_groups = [aws_security_group.asg_sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "tech_test_asg" {
  launch_configuration = aws_launch_configuration.tech_test_asg_lc.id
  availability_zones   = data.aws_availability_zones.all.names
  min_size             = 3
  max_size             = 5
  desired_capacity     = 3

  target_group_arns = [aws_lb_target_group.tech_test_tg.arn]
  health_check_type = "ELB"

  tag {
    key                 = "Resource"
    value               = "TechTest"
    propagate_at_launch = true
  }
}

# ASG Scaling policies defined here 

# scale up alarm
resource "aws_autoscaling_policy" "cpu_policy_up" {
  name                   = "example-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.tech_test_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "30"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "${var.service}-cpu-up-alarm"
  alarm_description   = "${var.service}-cpu-up-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = var.cpu_max_threshold
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.tech_test_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.cpu_policy_up.arn]
}

# scale down alarm
resource "aws_autoscaling_policy" "cpu_policy_down" {
  name                   = "${var.service}-cpu-policy-down"
  autoscaling_group_name = aws_autoscaling_group.tech_test_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "30"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm_down" {
  alarm_name          = "${var.service}-cpu-alarm-down"
  alarm_description   = "${var.service}-cpu-alarm-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = var.cpu_min_threshold
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.tech_test_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.cpu_policy_down.arn]
}

