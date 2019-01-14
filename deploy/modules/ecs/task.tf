// the task definition for the nginx service
data "template_file" "nginx_container" {
  template = "${file("${path.module}/containers/nginx.json")}"

  vars {
    image     = "${var.nginx_repository_name}"
    log_group = "${aws_cloudwatch_log_group.log_group.name}"
  }
}

data "template_file" "go_container" {
  template = "${file("${path.module}/containers/go.json")}"

  vars {
    image     = "${var.go_repository_name}"
    log_group = "${aws_cloudwatch_log_group.log_group.name}"
  }
}

data "template_file" "node_container" {
  template = "${file("${path.module}/containers/node.json")}"

  vars {
    image     = "${var.node_repository_name}"
    log_group = "${aws_cloudwatch_log_group.log_group.name}"
  }
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "${var.environment}_ecs_task"
  container_definitions    = "[${data.template_file.nginx_container.rendered}, ${data.template_file.go_container.rendered}, ${data.template_file.node_container.rendered}]"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = "${aws_iam_role.ecs_execution_role.arn}"
  task_role_arn            = "${aws_iam_role.ecs_execution_role.arn}"
}
