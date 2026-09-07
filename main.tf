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
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
        #roboshop-dev-public-us-east-la/1b
        Name = "${var.project}-${var.environment}-public-${data.aws_availability_zones.available.names[count.index]}"
    },
    var.public_subnet_tags
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
    var.private_subnet_tags
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
    var.database_subnet_tags
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
# public-aws-route-block
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  ### this is for internet gateway
  gateway_id                = aws_internet_gateway.main.id
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

resource "aws_eip" "elastic_ip" {
  domain = "vpc"

  tags = local.elastic_ip_final_tags
}

##### nat gateway-block #####
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet[0].id ###  hero 0 means us-east-1a

  tags = {
    Name = local.nat_gateway_final_tags
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

# private-aws-route-block
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  ### this is for nat gateway
  nat_gateway_id                = aws_nat_gateaway.this.id
}

# database-aws-route-block
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
   ### this is for nat gateway
  nat_gateway_id = aws_nat_gateway.this.id
}