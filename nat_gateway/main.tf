terraform {
  required_providers {
    aws = {
      version = "~> 3.31.0"
    }
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(var.subnet_ids, count.index)
  count         = var.subnet_count

  tags = {
    Name        = "${var.env}-${lower(substr(element(var.availability_zones, count.index), -1, 1))}"
    Environment = var.env
  }
}

resource "aws_eip" "nat" {
  vpc   = true
  count = var.subnet_count
}

