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

#public-subnet-block
resource "aws_subnet" "public_subnet" {
  count = length(var.cidr_block)
  vpc_id     = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.cidr_block[count.index ]

  tags = merge(
    local.common_tags,
    {
        #roboshop-dev-public-us-east-la/1b
        Name = "${var.project}-${var.environment}-public-${data.aws_availability_zones.available.names[count.index]}"
    },
    var.subnet_tags
    )
}

#private-subnet-block
resource "aws_subnet" "private_subnet" {
  count = length(var.cidr_block)
  vpc_id     = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.cidr_block[count.index ]

  tags = merge(
    local.common_tags,
    {
        #roboshop-dev-private-us-east-la/1b
        Name = "${var.project}-${var.environment}-private-${data.aws_availability_zones.available.names[count.index]}"
    },
    var.subnet_tags
    )
}

#database-subnet-block
resource "aws_subnet" "database_subnet" {
  count = length(var.cidr_block)
  vpc_id     = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.cidr_block[count.index ]

  tags = merge(
    local.common_tags,
    {
        #roboshop-dev-database-us-east-la/1b
        Name = "${var.project}-${var.environment}-database-${data.aws_availability_zones.available.names[count.index]}"
    },
    var.subnet_tags
    )
}