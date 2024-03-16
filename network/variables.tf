variable "vpc_cidr" {
}

variable "env" {
}

variable "destination_cidr_block" {
  default = "0.0.0.0/0"
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "internal_subnet_cidrs" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "depends_id" {
}
