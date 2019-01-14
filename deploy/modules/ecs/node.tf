resource "aws_ecs_service" "node" {
  name            = "${var.environment}-node"
  task_definition = "${aws_ecs_task_definition.ecs_task.family}:${max("${aws_ecs_task_definition.ecs_task.revision}", "1")}"
  desired_count   = 1
  launch_type     = "FARGATE"
  cluster         = "${aws_ecs_cluster.cluster.id}"

  depends_on = [
    "aws_iam_role_policy.ecs_service_role_policy",
    "aws_lb_target_group.lb_target_group",
  ]

  network_configuration {
    security_groups = ["${var.security_groups_ids}", "${aws_security_group.ecs_service_node.id}"]
    subnets         = ["${var.private_subnets_id}"]
  }
}

resource "aws_security_group" "ecs_service_node" {
  vpc_id      = "${var.vpc_id}"
  name        = "${var.environment}-ecs-service-node-sg"
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

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ecs_service_nginx.id}"]
  }

  tags {
    Name        = "${var.environment}-ecs-service-node-sg"
    Environment = "${var.environment}"
  }
}
