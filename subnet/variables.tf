variable "name" {
}

variable "env" {
}

variable "cidrs" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "vpc_id" {
}

variable "map_public_ip_on_launch" {
}
