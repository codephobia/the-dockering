variable "environment" {
  description = "The environment"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "security_groups_ids" {
  type        = "list"
  description = "The SGs to use"
}

variable "private_subnets_id" {
  type        = "list"
  description = "The private subnets to use"
}

variable "public_subnet_ids" {
  type        = "list"
  description = "The public subnets to use"
}

variable "nginx_repository_name" {
  description = "The docker image for the nginx container"
}

variable "go_repository_name" {
  description = "The docker image for the go container"
}

variable "node_repository_name" {
  description = "The docker image for the node container"
}
