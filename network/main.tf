terraform {
  required_providers {
    aws = {
      version = "~> 3.31.0"
    }
  }
}

module "vpc" {
  source = "../vpc"

  cidr = var.vpc_cidr
  env  = var.env
}

module "public_subnets" {
  source = "../subnet"

  name                    = "${var.env}-public"
  env                     = var.env
  vpc_id                  = module.vpc.id
  cidrs                   = var.public_subnet_cidrs
  availability_zones      = var.availability_zones
  map_public_ip_on_launch = true
}

module "private_subnets" {
  source = "../subnet"

  name                    = "${var.env}-private"
  env                     = var.env
  vpc_id                  = module.vpc.id
  cidrs                   = var.private_subnet_cidrs
  availability_zones      = var.availability_zones
  map_public_ip_on_launch = false
}

module "internal_subnets" {
  source = "../subnet"

  name                    = "${var.env}-internal"
  env                     = var.env
  vpc_id                  = module.vpc.id
  cidrs                   = var.internal_subnet_cidrs
  availability_zones      = var.availability_zones
  map_public_ip_on_launch = false
}

module "nat" {
  source = "../nat_gateway"

  env                = var.env
  subnet_ids         = flatten([module.public_subnets.ids])
  subnet_count       = length(var.public_subnet_cidrs)
  availability_zones = var.availability_zones
}

resource "aws_route" "public_igw_route" {
  count                  = length(var.public_subnet_cidrs)
  route_table_id         = element(flatten([module.public_subnets.route_table_ids]), count.index)
  gateway_id             = module.vpc.igw
  destination_cidr_block = var.destination_cidr_block
}

resource "aws_route" "private_nat_route" {
  count                  = length(var.private_subnet_cidrs)
  route_table_id         = element(flatten([module.private_subnets.route_table_ids]), count.index)
  nat_gateway_id         = element(flatten([module.nat.ids]), count.index)
  destination_cidr_block = var.destination_cidr_block
}

resource "aws_route" "internal_nat_route" {
  count                  = length(var.internal_subnet_cidrs)
  route_table_id         = element(flatten([module.internal_subnets.route_table_ids]), count.index)
  nat_gateway_id         = element(flatten([module.nat.ids]), count.index)
  destination_cidr_block = var.destination_cidr_block
}

resource "null_resource" "dummy_dependency" {
  depends_on = [module.nat]
}
