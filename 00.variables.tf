#### Variables #####

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "ID de la AMI para la instancia EC2"
  type        = string
  default     = "ami-080c353f4798a202f"  # Amazon Linux 2 en us-east-1
}

variable "server_name" {
  description = "Nombre del servidor"
  type        = string
  default     = "nginx_server"
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  default     = "Development"
  sensitive   = false
}
