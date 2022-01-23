resource "aws_instance" "sample" {
  ami           = "ami-04656078adf4aa403"
  instance_type = "t2.micro"
  vpc_security_group_ids = [var.SGID]

  tags = {
    Name = "sample"
  }
}
variable "SGID" {}