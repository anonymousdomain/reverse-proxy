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

  ami = "ami-07bff6261f14c3a45"

  instance_type = "t2.micro"

  vpc_security_group_ids = [module.nginx_server_security_group.security_group_id]

  tags = {
    Name = var.instance_name
  }
  key_name = "nginx-server.pem"

}
data "aws_vpc" "default" {
  default = true
}

module "nginx_server_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"
     name = "nginx_server-sg"
     
  vpc_id  = data.aws_vpc.default.id  
  ingress_rules = ["https-443-tcp","http-80-tcp","ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}

