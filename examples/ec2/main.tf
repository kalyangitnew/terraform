resource "aws_instance" "web" {
  ami           = "ami-04656078adf4aa403"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-0db1f455d56fb942d"]

  tags = {
    Name = "Sample"
  }
}