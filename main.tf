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

    
    provisioner "file" {
        source = "startup.sh"
        destination = "/home/ec2-user/startup.sh"

        connection {
            type = "ssh"
            user = "ec2-user"
            private_key = file("minecraft.pem")
            host = self.public_ip
        }
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /home/ec2-user/startup.sh",
            "sudo /home/ec2-user/startup.sh"
        ]

        connection {
            type = "ssh"
            user = "ec2-user"
            private_key = file("minecraft.pem")
            host = self.public_ip
        }
    }
    
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
