# # VPC Peering
# resource "aws_vpc_peering_connection" "vp" {
#   peer_vpc_id   = module.vpc_1.vpc_id
#   vpc_id        = module.vpc_2.vpc_id
#   auto_accept   = true

#   accepter {
#     allow_remote_vpc_dns_resolution = true
#   }

#   requester {
#     allow_remote_vpc_dns_resolution = true
#   }

#   tags = {
#     Name = "VPC_Peering"
#   }
# }

# locals {
#   requester_route_tables_ids = concat(module.vpc_1.public_route_table_ids, module.vpc_1.private_route_table_ids)
#   accepter_route_tables_ids  = concat(module.vpc_2.public_route_table_ids, module.vpc_2.private_route_table_ids)
# }

# resource "aws_route" "requester" {
#   count                     = length(local.requester_route_tables_ids)
#   route_table_id            = local.requester_route_tables_ids[count.index]
#   destination_cidr_block    = module.vpc_2.vpc_cidr_block
#   vpc_peering_connection_id = aws_vpc_peering_connection.vp.id
# }

# resource "aws_route" "accepter" {
#   count                     = length(local.accepter_route_tables_ids)
#   route_table_id            = local.accepter_route_tables_ids[count.index]
#   destination_cidr_block    = module.vpc_1.vpc_cidr_block
#   vpc_peering_connection_id = aws_vpc_peering_connection.vp.id
# }

# Private Link
data "aws_caller_identity" "current" {}

resource "aws_lb" "nlb" {
  name               = "service-provider-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = module.vpc_2.private_subnets

  enable_deletion_protection = false
}

resource "aws_vpc_endpoint_service" "vpc_endpoint" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.nlb.arn]
}

resource "aws_vpc_endpoint_service_allowed_principal" "endpoint_principal" {
  vpc_endpoint_service_id = aws_vpc_endpoint_service.vpc_endpoint.id
  principal_arn           = data.aws_caller_identity.current.arn
}

resource "aws_vpc_endpoint" "this" {
  service_name      = aws_vpc_endpoint_service.vpc_endpoint.service_name
  subnet_ids        = module.vpc_1.private_subnets
  vpc_endpoint_type = "Interface"
  vpc_id            = module.vpc_1.vpc_id
}