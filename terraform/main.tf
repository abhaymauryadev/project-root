provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "fullstack" {
  ami = "ami-0ec10929233384c7f" # ubuntu
  instance_type = "t2.micro"

  key_name = var.key_name
  
  security_groups = [aws_security_group.web_sg.name]

  user_data = file("userdata.sh")

  tags = {
    Name = "Fullstack_EC2"
  }
}

resource "aws_security_group" "web_sg" {
  name = "web_sg"

  ingress = {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress = {
     from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress = {
     from_port = 5000
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}