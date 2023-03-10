variable "vpc_name" {
  type = string
  default = "mhsong-vpc"
}

variable "vpc_cidr" {
  type = string
  default = "192.168.0.0/16"
}

variable "public_subnet_number" {
  description = "public subnet number"
  type = number
  # default = 2
  default = 1
}

variable "public_subnet_cidrs" {
  description = "cidr should be match with public_subnet_number"
  type = list(string)
  # default = ["192.168.10.0/24", "192.168.20.0/24"]
  default = ["192.168.10.0/24"]
}

variable "private_subnet_number" {
  description = "private subnet number"
  type = number
  # default = 2
  default = 1
}

variable "private_subnet_cidrs" {
  description = "cidr should be match with private_subnet_number"
  type = list(string)
  # default = ["192.168.11.0/24", "192.168.21.0/24"]
  default = ["192.168.11.0/24"]
}