# Infra: 2 VPC includin Subnets
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "vpc_1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "vpc_no_1_vic"

  cidr = "10.1.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets  = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "VPC_number" = "VPC_1"
  }

  private_subnet_tags = {
    "VPC_number" = "VPC_1"
  }
}

module "vpc_2" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "vpc_no_2_vic"

  cidr = "10.2.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
  public_subnets  = ["10.2.4.0/24", "10.2.5.0/24", "10.2.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "VPC_number" = "VPC_2"
  }

  private_subnet_tags = {
    "VPC_number" = "VPC_2"
  }
}