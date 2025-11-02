#### provider #####
# Define el proveedor de nube que Terraform usará, en este caso, AWS.
# También establece la región por defecto donde se crearán los recursos.
provider "aws" {
  region = "us-east-1"
}