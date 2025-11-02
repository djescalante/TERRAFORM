# Este bloque define un recurso que Terraform debe crear y gestionar: un par de claves SSH.
resource "aws_key_pair" "nginx_server_ssh_key" {
  key_name   = "${var.server_name}-${var.environment}-ssh-key"
  public_key = file("./keys/${var.server_name}.key.pub")
  tags = {
    Name = "${var.server_name}-${var.environment}-ssh-key"
    Environment = "${var.environment}"
    owner = "Jose Escalante"
    Team = "DevOps"
    project = "Terraform Practice"
  } 
  
  
}