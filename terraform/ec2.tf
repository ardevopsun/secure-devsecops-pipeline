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
  ami                    = "ami-05ffe3c48a9991133" # Amazon Linux 2023
  instance_type          = "t2.micro"
  key_name               = "devsecops-key"         # Use existing key pair name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "DevSecOps-EC2"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y

              # Docker
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ec2-user

              # Git
              yum install -y git

              # AWS CLI v2
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              yum install -y unzip
              unzip awscliv2.zip
              ./aws/install
              rm -rf aws awscliv2.zip

              # Node.js
              curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
              yum install -y nodejs

              # Terraform
              curl -fsSL -o terraform.zip https://releases.hashicorp.com/terraform/1.8.5/terraform_1.8.5_linux_amd64.zip
              unzip terraform.zip
              mv terraform /usr/local/bin/
              chmod +x /usr/local/bin/terraform
              rm terraform.zip
              EOF
}
