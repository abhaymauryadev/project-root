# provider "aws" {
#   region = var.region
# }

# # Security Group
# resource "aws_security_group" "web_sg" {
#   name = "web-sg"

#   # SSH
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Flask
#   ingress {
#     from_port   = 5000
#     to_port     = 5000
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Express
#   ingress {
#     from_port   = 3000
#     to_port     = 3000
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Allow internal communication
#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     self        = true
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Flask EC2
# resource "aws_instance" "flask" {
#   ami           = "ami-0ec10929233384c7f"
#   instance_type = "t3.micro"
#   key_name      = var.key_name

#   security_groups = [aws_security_group.web_sg.name]

#   user_data = file("flask.sh")

#   tags = {
#     Name = "Flask-Server"
#   }
# }

# # Express EC2
# resource "aws_instance" "express" {
#   ami           = "ami-0ec10929233384c7f"
#   instance_type = "t3.micro"
#   key_name      = var.key_name

#   security_groups = [aws_security_group.web_sg.name]

#   user_data = file("express.sh")

#   tags = {
#     Name = "Express-Server"
#   }
# }