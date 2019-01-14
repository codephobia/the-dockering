resource "aws_cloudwatch_log_group" "log_group" {
  name = "the-dockering"

  tags {
    Environment = "${var.environment}"
    Application = "TheDockering"
  }
}
