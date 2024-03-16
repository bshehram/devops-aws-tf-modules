output "id" {
  value = aws_vpc.main.id
}

output "cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "security_group_id" {
  value = aws_default_security_group.main.id
}

output "igw" {
  value = aws_internet_gateway.main.id
}

