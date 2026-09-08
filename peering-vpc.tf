resource "aws_vpc_peering_connection" "default" {
    count = var.is_peering_enabled ? 1 : 0
  #peer_owner_id = var.peer_owner_id
  #accepter
  peer_vpc_id   = aws_vpc.default.id
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