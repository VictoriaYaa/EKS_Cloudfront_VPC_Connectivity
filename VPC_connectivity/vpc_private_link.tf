# Private Link
data "aws_caller_identity" "current" {}

resource "aws_lb" "nlb" {
  name               = "nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = module.vpc_1.private_subnets

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "lb_tg" {
  name     = "lb-tg"
  port     = 22
  protocol = "TCP"
  vpc_id   = module.vpc_1.vpc_id
}

resource "aws_lb_target_group_attachment" "lb_tg_attach" {
  target_group_arn = aws_lb_target_group.lb_tg.arn
  target_id        = aws_instance.instance_1.id
  port             = 22
}

resource "aws_lb_listener" "lb_listener_vpc1" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "22"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }
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