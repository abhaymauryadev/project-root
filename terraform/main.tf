resource "aws_instance" "fullstack" {
  ami           = "ami-0ec10929233384c7f"
  instance_type = "t3.micro"

  key_name = var.key_name

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "Fullstack-EC2"
  }
}

provider "aws" {
  region = "us-east-1"
}
resource "aws_security_group" "web_sg" {
  name = "web_sg"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Frontend (React/Next)
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Backend (Flask)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound (VERY IMPORTANT — this is egress, not ingress)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}