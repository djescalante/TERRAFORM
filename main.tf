#### provider #####
# Define el proveedor de nube que Terraform usará, en este caso, AWS.
# También establece la región por defecto donde se crearán los recursos.
provider "aws" {
  region = "us-east-1"
}

#### data source (Búsqueda Dinámica de AMI) #####
# Este bloque no crea nada, sino que busca información existente en AWS.
# Su objetivo es encontrar el ID de la AMI (Amazon Machine Image) más reciente de Amazon Linux 2.
data "aws_ami" "amazon_linux_2" {
  # 'most_recent = true' le indica a Terraform que, de todas las AMIs que coincidan,
  # elija la que fue creada más recientemente.
  most_recent = true

  # 'owners = ["amazon"]' filtra las AMIs para que solo se consideren aquellas
  # publicadas oficialmente por Amazon. Esto es una buena práctica de seguridad.
  owners      = ["amazon"]

  # 'filter' permite especificar criterios de búsqueda más detallados.
  filter {
    # Filtramos por el nombre de la AMI.
    name   = "name"
    # 'values' contiene el patrón del nombre a buscar. El asterisco (*) es un comodín
    # que coincide con cualquier caracter, permitiendo encontrar diferentes versiones
    # de Amazon Linux 2 (amzn2-ami-hvm-*-x86_64-gp2).
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


#### resource #####
# Este bloque define un recurso que Terraform debe crear y gestionar: una instancia EC2.
resource "aws_instance" "nginx_server" {
  # En lugar de un ID de AMI fijo, usamos el resultado de nuestra búsqueda dinámica.
  # 'data.aws_ami.amazon_linux_2.id' obtiene el ID de la AMI encontrada en el bloque 'data'.
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"

 
  # 'user_data' es un script que se ejecuta automáticamente la primera vez que la instancia arranca.
  # Es ideal para instalar software o realizar configuraciones iniciales.
  user_data = <<EOF
                #!/bin/bash -xe
                yum update -y
                amazon-linux-extras install -y nginx1
                systemctl enable --now nginx
                EOF
  key_name = aws_key_pair.nginx_server_ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  tags = {
    Name = "NginxServer"
    Environment = "Development"
    owner = "Jose Escalante"
    Team = "DevOps"
    project = "Terraform Practice"
  } 
  
}

# Este bloque define un recurso que Terraform debe crear y gestionar: un par de claves SSH.
resource "aws_key_pair" "nginx_server_ssh_key" {
  key_name   = "nginxserver.key"
  public_key = file("./keys/nginx-server.key.pub")
    tags = {
    Name = "NginxServer-SSH-Key"
    Environment = "Development"
    owner = "Jose Escalante"
    Team = "DevOps"
    project = "Terraform Practice"
  } 
  
  
}

#Seguridad para la instancia EC2
resource "aws_security_group" "nginx_sg" {
  name        = "nginx_sg"
  description = "Allow HTTP and SSH traffic"

  ingress  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  tags = {
    Name = "NginxServer-SG"
    Environment = "Development"
    owner = "Jose Escalante"
    Team = "DevOps"
    project = "Terraform Practice"
  }
}

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
