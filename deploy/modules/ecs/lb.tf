resource "aws_lb_target_group" "lb_target_group" {
  name        = "${var.environment}-lb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${var.vpc_id}"
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }
}

// security group for LB
resource "aws_security_group" "web_inbound_sg" {
  name        = "${var.environment}-web-inbound-sg"
  description = "Allow HTTP from Anywhere into LB"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.environment}-web-inbound-sg"
  }
}

resource "aws_lb" "lb_the_dockering" {
  name            = "${var.environment}-lb-the-dockering"
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${var.security_groups_ids}", "${aws_security_group.web_inbound_sg.id}"]

  tags {
    Name        = "${var.environment}-lb-the-dockering"
    Environment = "${var.environment}"
  }
}

resource "aws_lb_listener" "the_dockering" {
  load_balancer_arn = "${aws_lb.lb_the_dockering.arn}"
  port              = "80"
  protocol          = "HTTP"
  depends_on        = ["aws_lb_target_group.lb_target_group"]

  default_action {
    target_group_arn = "${aws_lb_target_group.lb_target_group.arn}"
    type             = "forward"
  }
}
