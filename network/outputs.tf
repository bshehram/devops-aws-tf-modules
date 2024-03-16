output "vpc_id" {
  value = module.vpc.id
}

output "vpc_cidr" {
  value = module.vpc.cidr_block
}

output "vpc_security_group_id" {
  value = module.vpc.security_group_id
}

output "public_subnet_ids" {
  value = module.public_subnets.ids
}

output "private_subnet_ids" {
  value = module.private_subnets.ids
}

output "internal_subnet_ids" {
  value = module.internal_subnets.ids
}

output "depends_id" {
  value = null_resource.dummy_dependency.id
}

output "public_route_table_ids" {
  value = [
    module.public_subnets.route_table_ids,
  ]
}

output "private_route_table_ids" {
  value = [
    module.private_subnets.route_table_ids,
  ]
}

output "internal_route_table_ids" {
  value = [
    module.internal_subnets.route_table_ids,
  ]
}
