resource "aws_ecs_service" "nginx" {
  name            = "${var.environment}-nginx"
  task_definition = "${aws_ecs_task_definition.ecs_task.family}:${max("${aws_ecs_task_definition.ecs_task.revision}", "1")}"
  desired_count   = 1
  launch_type     = "FARGATE"
  cluster         = "${aws_ecs_cluster.cluster.id}"

  depends_on = [
    "aws_iam_role_policy.ecs_service_role_policy",
    "aws_lb_target_group.lb_target_group",
  ]

  network_configuration {
    security_groups = ["${var.security_groups_ids}", "${aws_security_group.ecs_service_nginx.id}"]
    subnets         = ["${var.private_subnets_id}"]
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.lb_target_group.arn}"
    container_name   = "the-dockering-nginx"
    container_port   = "80"
  }
}

resource "aws_security_group" "ecs_service_nginx" {
  vpc_id      = "${var.vpc_id}"
  name        = "${var.environment}-ecs-service-nginx-sg"
  description = "Allow egress from container"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-ecs-service-nginx-sg"
    Environment = "${var.environment}"
  }
}
