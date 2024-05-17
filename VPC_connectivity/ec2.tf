resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key_vic"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/KQVkVU7mDBZoIpTT/Hx1kBGlHVXfUu1XbQ7udQoDlX9h+rUpnA8BFz+BhOiEPJF3k4bL4AG8G8cEIU/ILzON3gzKgs8gAo1NpkeKKwTczhjByEnzNUguFsKtNADR+T64JjHVSW8hHpdjSX8343REM/+e3SVxNqDmr0hgO+goACqAUYAXlx0F4bhEA1sBsrpqArWkvTHKUYX1xUXT+IK5vk8SqDK1zPC72IGCnpNNEc2Hia2lpGNL8fFsRQx9mFgDCFw8rCLkjLgb6Ijeo//+68HOzyMf60NDiHKHBYSrumJzPDxe+5gX1loHmhUOaq3nZiWUMxxbgeYpuL64x8R4iwB/IDh//MtIYTeZN40S++GnqMbFismfLaB9kNupdCHbnvtxtr8cfWlMD2GQ3UvI8Lwpwk3WcBNqT4DCN1Zq8zzg8xq+Qt+V3SXg9i7NUnD7GrXP4UoNpwW1FPZSW1EnatVrpySwQ9ZrxHiP/y7sJLXIiavGM4K9qadlLCPGN9j8ISqWGzjQELm7RwdSUWUsCNriteHYHKrduFDZfLiLU6U/wzQ8HBqgjZLb96Ewf5sdgAmg9joHsUIXwdSkJUanWhiygRy7w5zBdC4i/kMzQ7Gd2UKBdCUnBpDGomNBbnN3HzSGv94Xvu1ko7Re2HBgX3QbRH2AJtSOHc9vkr71TQ== victoria@gmail.com"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow ALL inbound traffic and all outbound traffic"
  vpc_id      = module.vpc_1.vpc_id

  tags = {
    Name = "allow_all"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all" {
  security_group_id = aws_security_group.allow_all.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.allow_all.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_instance" "instance_1" {
 ami = "ami-02bf8ce06a8ed6092"
 instance_type = "t2.micro"
 key_name = "${aws_key_pair.ssh_key.key_name}"
 subnet_id = module.vpc_1.public_subnets[0]
 associate_public_ip_address = "true"
 security_groups = ["${aws_security_group.allow_all.id}"]
 
 tags = {
  Name = "linux_1"
 }
}