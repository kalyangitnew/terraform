resource "aws_security_group" "allow_sample" {
  name        = "allow_sample"
  description = "Allow sample traffic"

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    self = false
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    self = false
  }

  tags = {
    Name = "allow_sample"
  }
}
output "SGID" {
  value = "aws_security_group.allow_sample.id"
}