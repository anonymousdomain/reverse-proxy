terraform {

  cloud {
    organization = "son_of_anton"
    workspaces {
      name = "nginx"
    }
  }
  required_providers {

    aws = {

      source  = "hashicorp/aws"
      version = "~> 4.16 "

    }

  }

  required_version = ">= 1.2.0"
}

provider "aws" {

  region = "us-west-2"

}

resource "aws_instance" "nginx_server" {

#   ami = "ami-01e82af4e524a0aa3"
  ami = "ami-07bff6261f14c3a45"

  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.nginx_server_rule.id]
#   subnet_id = "subnet-09399a9d804de1bef"

  tags = {
    Name = var.instance_name
  }
  key_name = "nginx-server.pem"

}

resource "aws_security_group" "nginx_server_rule" {
    name = "nginx_server_rule-sg"
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



