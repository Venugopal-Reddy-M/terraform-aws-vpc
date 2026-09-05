variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
  
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_tag" {
  type = map
  default = {}
}

variable "igw_tags" {
  type = map
  default = {}
}

variable "public_cidr_block" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_cidr_block" {
  type = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "database_cidr_block" {
  type = list(string)
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "subnet_tags" {
  type = map
  default = {}
}

variable "public_route_table_tags" {
  type = map
  default = {}
}

variable "private_route_table_tags" {
  type = map
  default = {}
}
variable "database_route_table_tags" {
  type = map
  default = {}
}