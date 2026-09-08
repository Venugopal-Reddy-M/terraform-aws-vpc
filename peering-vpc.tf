resource "aws_vpc_peering_connection" "default" {
    count = var.is_peering_enabled ? 1 : 0
  #peer_owner_id = var.peer_owner_id
  #accepter
  peer_vpc_id   = data.aws_vpc.default.id
  #requester/my-vpc/our-vpc
  vpc_id        = aws_vpc.main.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
  auto_accept = true

  tags = local.vpc_peering_final_tags
}


# Create a route/roboshop-dev-default
resource "aws_route" "public_to_peer" {
    count = var.is_peering_enabled ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc_peering_connection.default.cidr_block
  vpc_peering_connection_id = data.aws_vpc_peering_connection.default[count.index].id
}

# Create a route/default-to-roboshop-dev
resource "aws_route" "peer_to_public" {
    count = var.is_peering_enabled ? 1 : 0
  route_table_id            = data.aws_route_table.default.id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = data.aws_vpc_peering_connection.default[count.index].id
}
