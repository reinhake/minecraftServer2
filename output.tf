output "minecraft_public_ip" {
  description = "Ouputs the public IP of the created server"
  value       = aws_instance.minecraft.public_ip
}