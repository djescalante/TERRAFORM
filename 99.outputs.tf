#### output #####
# Este bloque define una salida que Terraform mostrará después de aplicar la configuración.
# En este caso, muestra la dirección IP pública de la instancia EC2 creada.
output "nginx_server_public_ip" {
  description = "Direccion ip publica de la instancia EC2"
  value = aws_instance.nginx_server.public_ip
} 
output "nginx_server_private_ip" {
  description = "Direccion ip privada de la instancia EC2"
  value = aws_instance.nginx_server.private_ip
}
output "nginx_server_public_dns" {
  description = "Direccion DNS publica de la instancia EC2"
  value = aws_instance.nginx_server.public_dns
}
output "nginx_server_private_dns" {
  description = "Direccion DNS privada de la instancia EC2"
  value = aws_instance.nginx_server.private_dns
}
## comando conexion ssh##
output "ssh_connection_command" {
  description = "Comando para conectar via SSH a la instancia EC2"
  value = "ssh -i ./keys/nginx-server.key ec2-user@${aws_instance.nginx_server.public_ip}"
}
