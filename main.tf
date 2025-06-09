# main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "minecraft" {
  ami           = "ami-0e63f5cb6f14d1dcf"
  instance_type = "t3.small"

  key_name = "minecraft"

  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]

  user_data = file("startup.sh")

  tags = {
    Name = "MinecraftServer"
  }
}

resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft_sg"
  description = "Allow for connections to the server"

  ingress {
    from_port  = 25565
    to_port    = 25565
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port  = 22
    to_port    = 22
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
