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
  count = length(var.public_cidr_block)
  vpc_id     = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.public_cidr_block[count.index ]

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
  count = length(var.private_cidr_block)
  vpc_id     = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.private_cidr_block[count.index ]

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
  count = length(var.database_cidr_block)
  vpc_id     = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.database_cidr_block[count.index ]

  tags = merge(
    local.common_tags,
    {
        #roboshop-dev-database-us-east-la/1b
        Name = "${var.project}-${var.environment}-database-${data.aws_availability_zones.available.names[count.index]}"
    },
    var.subnet_tags
    )
}

# public-route-table-block
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = local.route_table_public_final_tags
}
#private-route-table-block
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = local.route_table_private_final_tags
}
#database-route-table-block
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = local.route_table_database_final_tags
}

# public-subnet_association-route-block
resource "aws_route_table_association" "public" {
 count = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

# private-subnet_association-route-block
resource "aws_route_table_association" "private" {
 count = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private.id
}

# database-subnet_association-route-block
resource "aws_route_table_association" "database" {
 count = length(aws_subnet.database_subnet)
  subnet_id      = aws_subnet.database_subnet[count.index].id
  route_table_id = aws_route_table.database.id
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}