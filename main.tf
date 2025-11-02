#### modulos ####
module "nginx_server-dev" {
  source = "./nginx_server_module"

  ami_id        = "ami-080c353f4798a202f"
  instance_type = "t3.micro"
  server_name   = "nginx_server-dev"
  environment   = "development"
}

module "nginx_server-qa" {
  source = "./nginx_server_module"

  ami_id        = "ami-080c353f4798a202f"
  instance_type = "t3.micro"
  server_name   = "nginx_server-dev"
  environment   = "qa"
}

#### outputs development ####
output "nginx_dev_server_publicip" {
  description = "Direccion ip publica de la instancia EC2"
  value       = module.nginx_server-dev.nginx_server_public_ip
}
output "nginx_dev_server_privateip" {
  description = "Direccion ip privada de la instancia EC2"
  value       = module.nginx_server-dev.nginx_server_private_ip
}
output "nginx_dev_server_public_dns" {
  description = "Direccion DNS publica de la instancia EC2"
  value       = module.nginx_server-dev.nginx_server_public_dns
}

output "nginx_dev_server_private_dns" {
  description = "Direccion DNS privada de la instancia EC2"
  value       = module.nginx_server-dev.nginx_server_private_dns
}   
## comando conexion ssh##
output "ssh_connection_command_dev" {
  description = "Comando para conectar via SSH a la instancia EC2"
  value       = module.nginx_server-dev.ssh_connection_command
}

### outputs qa ####
output "nginx_qa_server_publicip" {
  description = "Direccion ip publica de la instancia EC2"
  value       = module.nginx_server-qa.nginx_server_public_ip
}
output "nginx_qa_server_privateip" {
  description = "Direccion ip privada de la instancia EC2"
  value       = module.nginx_server-qa.nginx_server_private_ip
}
output "nginx_qa_server_public_dns" {
  description = "Direccion DNS publica de la instancia EC2"
  value       = module.nginx_server-qa.nginx_server_public_dns
}
output "nginx_qa_server_private_dns" {
  description = "Direccion DNS privada de la instancia EC2"
  value       = module.nginx_server-qa.nginx_server_private_dns
}
## comando conexion ssh##
output "ssh_connection_command_qa" {
  description = "Comando para conectar via SSH a la instancia EC2"
  value       = module.nginx_server-qa.ssh_connection_command
}
