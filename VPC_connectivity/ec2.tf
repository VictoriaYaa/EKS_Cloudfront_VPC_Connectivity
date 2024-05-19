resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key_vic"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCIrz59MxK/I/Xww2NUhpaSEJrzXjk3k86YJJ12B7iv6XAbycBloLpDYDrUWKgtU9t4N3zHdz6wJFCxJipVFHwfgxE9rVBnUJfEipS0U23z8EGjMHQoBpJQ844HAlcld1+WJl1GHCxth3CNvrEA0UUiQGT68plS75bJMJ4svk5Rx37F1BsaFtHuZF1VL4WlQITTopNEwm+lFn3fM4fpVnwSlSEuOfmOYC7IRKyO5zaYMQJJ/iTYvJTKdFmsM8A1p+mJWEmdExEsl1u6fmpYS6BYu0FtfZGqMir8gOICby24v0tdIs203mOe4mDhdGeJINdSzszoQU5DqHv6Z2qi2kafv5Y0DGB2INB4PgJhXWEC3GaBvUIYGLYEIIwclGTRuMUG3+RagTKIUkX3JfZmx43tt4q6bw3ntSUWMthTg0tbgIrfzom3pemNuH9dUJopx8PJU0P+YnyhWNPklYzWOMzcpcoYt53zqr6Xn+SOUR0nejTKBsK0XM8LnyC6Fd/apMtT3DOC3vnqjKI/UHufbYpLHbFK8PZYedM/IFCIvbtpFYMwFPQoJhznghu/cFb+Mlen7tsfOMrVvr/UitWSVHY2f4THuEyfWGFcZIxh6u3QxI4H9Liw4umzWQcuPUA1UQuwW6U4iRSYzqnLi7vKE+AlGMLwihvkMakR9GfCU536Q== victoriayaakov@Victorias-MacBook-Pro.local"
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
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.allow_all.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_instance" "instance_1" {
 ami = "ami-02bf8ce06a8ed6092"
 instance_type = "t3.small"
 key_name = "${aws_key_pair.ssh_key.key_name}"
 subnet_id = module.vpc_1.public_subnets[0]
 associate_public_ip_address = "false"
 security_groups = ["${aws_security_group.allow_all.id}"]

 lifecycle {
    create_before_destroy = true
    ignore_changes        = [security_groups]
  }
 
 tags = {
  Name = "linux_1"
 }
}



resource "aws_security_group" "allow_all_2" {
  name        = "allow_all"
  description = "Allow ALL inbound traffic and all outbound traffic"
  vpc_id      = module.vpc_2.vpc_id

  tags = {
    Name = "allow_all_2"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_2" {
  security_group_id = aws_security_group.allow_all_2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_2" {
  security_group_id = aws_security_group.allow_all_2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_instance" "instance_2" {
 ami = "ami-02bf8ce06a8ed6092"
 instance_type = "t3.small"
 key_name = "${aws_key_pair.ssh_key.key_name}"
 subnet_id = module.vpc_2.public_subnets[0]
 associate_public_ip_address = "true"
 security_groups = ["${aws_security_group.allow_all_2.id}"]

 lifecycle {
    create_before_destroy = true
    ignore_changes        = [security_groups]
  }
 
 tags = {
  Name = "linux_2"
 }
}