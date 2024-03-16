resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = element(var.cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.cidrs)
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "${var.optional_prefix}subnet-${var.name}-${lower(substr(element(var.availability_zones, count.index), -1, 1))}"
  }
}

resource "aws_route_table" "subnet" {
  vpc_id = var.vpc_id
  count  = length(var.cidrs)

  tags = {
    Name = "${var.optional_prefix}rtb-${var.name}-${lower(substr(element(var.availability_zones, count.index), -1, 1))}"
  }
}

resource "aws_route_table_association" "subnet" {
  subnet_id      = element(aws_subnet.subnet.*.id, count.index)
  route_table_id = element(aws_route_table.subnet.*.id, count.index)
  count          = length(var.cidrs)
}
