resource "aws_vpc_endpoint" "s3" {
  vpc_id       = module.vpc.id
  service_name = "com.amazonaws.us-east-1.s3"

  tags = {
    Name = "${var.env}-s3"
  }
}

resource "aws_vpc_endpoint_route_table_association" "s3-pub" {
  count           = length(flatten([module.public_subnets.route_table_ids]))
  route_table_id  = element(flatten([module.public_subnets.route_table_ids]), count.index)
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_route_table_association" "s3-priv" {
  count           = length(flatten([module.private_subnets.route_table_ids]))
  route_table_id  = element(flatten([module.private_subnets.route_table_ids]), count.index)
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_route_table_association" "s3-int" {
  count           = length(flatten([module.internal_subnets.route_table_ids]))
  route_table_id  = element(flatten([module.internal_subnets.route_table_ids]), count.index)
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = module.vpc.id
  service_name = "com.amazonaws.us-east-1.dynamodb"

  tags = {
    Name = "${var.env}-dynamodb"
  }
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb-pub" {
  count           = length(flatten([module.public_subnets.route_table_ids]))
  route_table_id  = element(flatten([module.public_subnets.route_table_ids]), count.index)
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb-priv" {
  count           = length(flatten([module.private_subnets.route_table_ids]))
  route_table_id  = element(flatten([module.private_subnets.route_table_ids]), count.index)
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb-int" {
  count           = length(flatten([module.internal_subnets.route_table_ids]))
  route_table_id  = element(flatten([module.internal_subnets.route_table_ids]), count.index)
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
}
