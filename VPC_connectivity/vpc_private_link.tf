# Private Link
data "aws_caller_identity" "current" {}

resource "aws_lb" "nlb" {
  name               = "nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = module.vpc_1.private_subnets

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

resource "aws_vpc_endpoint" "vpc_endpoint_vpc_2" {
  service_name      = aws_vpc_endpoint_service.vpc_endpoint.service_name
  subnet_ids        = module.vpc_2.private_subnets
  vpc_endpoint_type = "Interface"
  vpc_id            = module.vpc_2.vpc_id
}