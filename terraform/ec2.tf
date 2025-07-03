provider "aws" {
  region = "us-east-1"
}

# Use default VPC for simplicity
data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH, HTTP access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  ingress {
    description      = "Allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  egress {
    description      = "Allow all outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  tags = {
    Name = "web-sg"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-020cba7c55df1f615" # Amazon Linux 2023
  instance_type          = "t2.medium"
  key_name               = "devsecops-key"         # Use existing key pair name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "DevSecOps-EC2"
  }

  user_data = <<-EOF
              #!/bin/bash
              set -e

              # Update system
              apt-get update -y && apt-get upgrade -y

              # Install Docker
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ubuntu
              newgrp docker

              # Install Git
              apt-get install -y git

              # Install AWS CLI v2
              apt-get install -y unzip curl
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              ./aws/install
              rm -rf aws awscliv2.zip

              # Install Node.js (v18)
              curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
              apt-get install -y nodejs

              # Install Terraform
              curl -fsSL -o terraform.zip https://releases.hashicorp.com/terraform/1.8.5/terraform_1.8.5_linux_amd64.zip
              unzip terraform.zip
              mv terraform /usr/local/bin/
              chmod +x /usr/local/bin/terraform
              rm terraform.zip
              EOF
}
