locals {
  production_availability_zones = ["us-west-2a", "us-west-2b"]
  environment                   = "production"
}

module "networking" {
  source               = "./modules/networking"
  environment          = "${local.environment}"
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr = ["10.0.10.0/24", "10.0.20.0/24"]
  availability_zones   = "${local.production_availability_zones}"
}

module "ecs" {
  source             = "./modules/ecs"
  environment        = "${local.environment}"
  vpc_id             = "${module.networking.vpc_id}"
  private_subnets_id = "${module.networking.private_subnets_id}"
  public_subnet_ids  = ["${module.networking.public_subnets_id}"]

  security_groups_ids = [
    "${module.networking.security_groups_ids}",
  ]

  nginx_repository_name = "codephobia/the-dockering-nginx:1.0.0"
  go_repository_name    = "codephobia/the-dockering-go:1.0.0"
  node_repository_name  = "codephobia/the-dockering-node:1.0.0"
}
