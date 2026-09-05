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

# variable "name" {
#   default = "roboshop-dev"
# }