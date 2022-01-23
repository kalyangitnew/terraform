resource "aws_spot_instance_request" "cheap_worker" {
  count         = length(var.components)
  ami           = data.aws_ami.ami.id
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-0db1f455d56fb942d"]
  wait_for_fulfillment = true

  tags = {
    Name = element(var.components,count.index)
  }
}
resource "aws_ec2_tag" "tags" {
  count       = length(var.components)
  key         = element("aws_spot_instance_request.cheap_worker.*.spot_instance_id, count.index")
  resource_id = "Name"
  value       = "element(var.components,count.index)"
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

