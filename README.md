# Terraform: EC2 con Nginx (AWS)

Proyecto Terraform para aprovisionar una instancia EC2 (Amazon Linux 2) con Nginx instalado y listo para servir HTTP. Incluye un módulo reutilizable (`nginx_server_module`) con Security Group y Key Pair.

## Requisitos
- Cuenta AWS con credenciales configuradas (`aws configure`).
- Terraform >= 1.3.
- Clave pública SSH en `keys/` para registrar el Key Pair en AWS.

## Estructura
- `main.tf`: ejemplo simple de instancia EC2 con `user_data` que instala Nginx.
- `nginx_server_module/`: módulo que crea EC2 + Security Group + Key Pair.
- `docs/`: material de apoyo del curso y notas.
- `.terraform.lock.hcl`: debe versionarse.
- `.gitignore`: ignora `.terraform/`, `*.tfstate`, `*.key`, planes, etc.

## Uso (módulo recomendado)
1) Genera tu par de claves SSH (si no tienes uno):
```
ssh-keygen -t rsa -b 4096 -C "dev" -f keys/nginx_server.key
# Esto crea:
#  - keys/nginx_server.key       (privada, NO subir a git)
#  - keys/nginx_server.key.pub   (pública)
```

2) Crea `terraform.tfvars` con tus variables (ejemplo):
```
# terraform.tfvars
instance_type = "t3.micro"
server_name   = "nginx_server"    # Debe coincidir con el nombre del archivo .key.pub
environment   = "Development"
# ami_id     = "ami-xxxxxxxx"     # Opcional; por defecto Amazon Linux 2 us-east-1
```
Asegúrate que exista `keys/nginx_server.key.pub` (o ajusta `server_name`).

3) Inicializa y aplica:
```
terraform init
terraform plan
terraform apply
```

4) Salidas útiles (outputs):
- `nginx_server_public_ip`
- `nginx_server_public_dns`
- `ssh_connection_command`

Abre `http://<nginx_server_public_ip>` para probar Nginx.

5) Destruir recursos cuando termines:
```
terraform destroy
```

## Uso (archivo simple `main.tf`)
El `main.tf` de la raíz incluye un ejemplo directo que:
- Usa Amazon Linux 2 en `us-east-1`.
- Instala Nginx vía `amazon-linux-extras`.
- Habilita e inicia el servicio.

Si prefieres este enfoque, asegúrate de tener un Security Group que permita `22/tcp` y `80/tcp` asociado a la instancia.

## Notas de seguridad
- No subas archivos sensibles: `*.key`, `*.tfvars` con secretos, estados `*.tfstate`. Ya están en `.gitignore`.
- El estado de Terraform puede contener datos sensibles; usa backend remoto con cifrado si es posible (S3 + DynamoDB).
- El archivo `.terraform.lock.hcl` se debe versionar.
- Si se subió una clave privada o binarios grandes al historial, rota la clave y reescribe el historial (ya se limpió `.terraform/` en este repo).

## Problemas comunes
- Security Group duplicado: si aparece `InvalidGroup.Duplicate`, importa el SG existente o usa `name_prefix`/un sufijo único.
- Nginx no se instala: revisa logs de cloud-init en la instancia `cat /var/log/cloud-init-output.log` y que la AMI sea Amazon Linux 2.
- Acceso SSH fallido: confirma que el Key Pair registrado coincida con tu `*.key` local y que el SG abra el puerto 22.

## Referencias
- Curso original usado como base: https://www.youtube.com/watch?v=_84CxYRv9Ik
- Terraform docs: https://developer.hashicorp.com/terraform/docs
- AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest

