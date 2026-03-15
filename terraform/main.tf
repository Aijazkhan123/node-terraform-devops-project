provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "devops_sg" {
  name = "node-terraform-sg-final"  # Changed to a unique name

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "devops_server" {
  ami           = "ami-0a14f53a6fe4dfcd1"
  instance_type = "t3.micro"

  security_groups = [aws_security_group.devops_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install docker.io -y
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo docker run -d -p 80:3000 nodejsonapp/node-terraform-project
              EOF

  tags = {
    Name = "DevOps-node-terraform-project Server"
  }
}

output "ec2_public_ip" {
  value = aws_instance.devops_server.public_ip
}
