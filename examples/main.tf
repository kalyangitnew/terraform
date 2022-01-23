provider "aws" {
  region = "us-east-1"
}

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
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_sample"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-04656078adf4aa403"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_sample.id,"sg-0db1f455d56fb942d"]

  tags = {
    Name = "Sample"
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-practice"
    key    = "example/sample/terraform.tfstate"
    region = "us-east-1"
  }
}