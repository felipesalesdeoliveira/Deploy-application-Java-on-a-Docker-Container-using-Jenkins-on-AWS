output "instance_public_ip" {
  description = "IP público da EC2 Jenkins + Docker"
  value       = aws_instance.devops.public_ip
}

output "instance_public_dns" {
  description = "DNS público da EC2"
  value       = aws_instance.devops.public_dns
}

output "ssh_connection_command" {
  description = "Comando SSH para conectar na instância"
  value       = "ssh -i ${var.key_name}.pem ec2-user@${aws_instance.devops.public_ip}"
}