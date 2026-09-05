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

variable "cidr_block" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "subnet_tags" {
  type = map
  default = {}
}

# variable "name" {
#   default = "roboshop-dev"
# }