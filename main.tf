resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = local.vpc_final_tags
}

#internet-gateway-block
resource "aws_internet_gateway" "main" {
  # vpc association
  vpc_id = aws_vpc.main.id

  tags = local.igw_final_tags
}

#subnet-block
resource "aws_subnet" "public_subnet" {
  count = length(var.cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block[count.index]

  tags = {
    Name = "Main"
  }
}