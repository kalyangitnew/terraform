resource "aws_spot_instance_request" "cheap_worker" {
  count                  = length(var.components)
  ami                    = data.aws_ami.ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-0db1f455d56fb942d"]
  wait_for_fulfillment   = true
  tags = {
    Name = element(var.components, count.index)
  }
}

resource "aws_ec2_tag" "tags" {
  count       = length(var.components)
  resource_id = element(aws_spot_instance_request.cheap_worker.*.spot_instance_id, count.index)
  key         = "Name"
  value       = element(var.components, count.index)
}

resource "aws_route53_record" "records" {
  count           = length(var.components)
  zone_id         = "Z01711311HI659T5X3F6I"
  name            = "${element(var.components, count.index)}-dev.roboshop.internal"
  type            = "A"
  ttl             = "300"
  records         = [element(aws_spot_instance_request.cheap_worker.*.private_ip, count.index)]
  allow_overwrite = true
}

resource "null_resource" "ansible" {
  depends_on = [aws_route53_record.records]
  count      = length(var.components)
  provisioner "remote-exec" {
    connection {
      host     = element(aws_spot_instance_request.cheap_worker.*.private_ip, count.index)
      user     = "centos"
      password = "DevOps321"
    }
    inline = [
      "sudo yum install python3-pip -y",
      "sudo pip3 install pip --upgrade",
      "sudo pip3 install ansible",
      "ansible-pull -U https://github.com/kalyangitnew/ansible.git roboshop-pull.yml -e COMPONENT=${element(var.components, count.index)} -e ENV=dev"
    ]
  }
}

data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "^Cent*"
  owners      = ["973714476881"]
}

variable "components" {
  default = ["frontend", "mongodb", "catalogue", "cart", "user", "redis", "mysql", "shipping", "rabbitmq", "payment"]
}

provider "aws" {
  region = "us-east-1"
}

#locals {
#  COMP_NAME = element(var.components, count.index)
#}
#
#