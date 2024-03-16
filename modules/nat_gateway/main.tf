resource "aws_nat_gateway" "nat" {
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(var.subnet_ids, count.index)
  count         = var.subnet_count

  tags = {
    Name = "${var.optional_prefix}nat-${lower(substr(element(var.availability_zones, count.index), -1, 1))}"
  }
}

resource "aws_eip" "nat" {
  domain   = "vpc"
  count = var.subnet_count
}
