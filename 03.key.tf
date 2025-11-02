# Este bloque define un recurso que Terraform debe crear y gestionar: un par de claves SSH.
resource "aws_key_pair" "nginx_server_ssh_key" {
  key_name   = "${var.server_name}-SSH-Key"
  public_key = file("./keys/nginx-server.key.pub")
  tags = {
    Name = "${var.server_name}-SSH-Key"
    Environment = var.environment
    owner = "Jose Escalante"
    Team = "DevOps"
    project = "Terraform Practice"
  } 
  
  
}