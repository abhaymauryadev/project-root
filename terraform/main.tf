# resource "aws_instance" "fullstack" {
#   ami           = "ami-0ec10929233384c7f"
#   instance_type = "t3.micro"

#   key_name = var.key_name

#   vpc_security_group_ids = [aws_security_group.web_sg.id]

#   tags = {
#     Name = "Fullstack-EC2"
#   }
# }

# provider "aws" {
#   region = "us-east-1"
# }
# resource "aws_security_group" "web_sg" {
#   name = "web_sg"

#   # SSH
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Frontend (React/Next)
#   ingress {
#     from_port   = 3000
#     to_port     = 3000
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Backend (Flask)
#   ingress {
#     from_port   = 5000
#     to_port     = 5000
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Outbound (VERY IMPORTANT — this is egress, not ingress)
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

provider "aws" {
  region = "us-east-1"
}


########################
# SECURITY GROUP (COMMON)
########################

resource "aws_security_group" "web_sg" {
  name = "multi-ec2-sg"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Express public
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Flask public (for testing)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Internal communication
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################
# FLASK EC2
########################

resource "aws_instance" "flask" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = file("flask.sh")

  tags = {
    Name = "Flask-EC2"
  }
}

########################
# EXPRESS EC2
########################

resource "aws_instance" "express" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = file("express.sh")

  tags = {
    Name = "Express-EC2"
  }
}