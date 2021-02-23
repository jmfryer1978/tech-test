resource "aws_security_group" "elb_sg" {
  name        = "${var.service}-elb-sg"
  description = "Security Group for the ELB"
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "asg_sg" {
  name        = "${var.service}-asg-sg"
  description = "Security Group for the ASG"
  tags = {
    Resource = "TechTest"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = var.server_port
    to_port         = var.server_port
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

