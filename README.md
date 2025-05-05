# Infraestrutura-wordpress-AWS

# 🛠️ Projeto Prático: Infraestrutura WordPress com Alta Disponibilidade na AWS

Este repositório documenta a construção de uma infraestrutura escalável e altamente disponível para hospedar o WordPress na AWS. A arquitetura utiliza serviços como EC2, EFS, RDS, Load Balancer e Auto Scaling.

---

## 📌 Visão Geral da Arquitetura

- 🖥️ **EC2**: Instâncias privadas para rodar containers WordPress.
- 📦 **Docker**: Empacotamento do WordPress.
- 📂 **EFS**: Compartilhamento de arquivos persistentes.
- 🛢️ **RDS**: Banco de dados MySQL gerenciado.
- 🌐 **ALB**: Application Load Balancer para distribuir tráfego.
- 🔒 **Security Groups**: Controle de acesso entre os componentes.
- 🔄 **Auto Scaling Group**: Escalabilidade automática.
- 🌉 **Subnets Públicas e Privadas**: Em uma VPC personalizada.

---

## 🧱 Passo a Passo de Configuração

### 1. Criar VPC e Subnets

![Captura de tela 2025-05-02 085252](https://github.com/user-attachments/assets/1f977941-c0c7-4ede-8234-5c8ce775507f)

![Captura de tela 2025-05-02 085301](https://github.com/user-attachments/assets/5e394c4e-a454-4281-ae3a-a1b82e01b4e1)

![Captura de tela 2025-05-02 085312](https://github.com/user-attachments/assets/031e625b-fa29-4f1d-81d5-706bea9da454)

- Criar uma VPC com IPv4 CIDR (ex: 10.0.0.0/16).

![Captura de tela 2025-05-02 085507](https://github.com/user-attachments/assets/67cf5b71-b506-46f1-898d-aba54a88a956)

- Criar duas subnets públicas (ex: us-east-1a e us-east-1b).
- Criar duas subnets privadas.

![Captura de tela 2025-05-02 085515](https://github.com/user-attachments/assets/3ef56997-5150-4d0e-9c9d-337a0c008f86)

- Criar uma NAT Gateway para permitir acesso à internet a partir das subnets privadas.

![Captura de tela 2025-05-02 085525](https://github.com/user-attachments/assets/e64f5c6a-cc77-4818-aeb7-4644ebeaffac)

- Ative o auto-assign IP das subnets públicas.
  
![Captura de tela 2025-05-02 085907](https://github.com/user-attachments/assets/b455fc3f-7f5b-4f14-a1e2-8f54b54ac5f4)

![Captura de tela 2025-05-02 085918](https://github.com/user-attachments/assets/58f47ad7-a068-4382-bc7d-dc45125370ea)

![Captura de tela 2025-05-02 085938](https://github.com/user-attachments/assets/6a0dc438-7291-4e4e-abd3-10a14fc9a468)

### 2. Security Groups
- **SG-ALB**: Permitir entrada na porta 80 de qualquer origem.
- **SG-EC2**: Permitir entrada na porta 80 apenas do SG-ALB.
- **SG-RDS**: Permitir entrada na porta 3306 apenas do SG-EC2.
- **SG-EFS**: Permitir entrada na porta 2049 do SG-EC2.
- **SG-Bastion**: Permitir SSH apenas do seu IP.

### 3. Banco de Dados (RDS)
- Engine: MySQL 8.x
- Multi-AZ: Opcional
- Credenciais: definir nome do DB, usuário e senha
- VPC: usar subnets privadas
- SG: usar SG-RDS

### 4. EFS (Elastic File System)
- Criar sistema de arquivos com ponto de montagem em subnets privadas
- Associar o SG-EFS
- Permitir acesso via NFS (2049)

### 5. EC2 Privada com Docker
- AMI: Ubuntu 24.04
- Subnet: Privada
- SG: SG-EC2

## Observação extra sobre EC2 e automação com User Data

Durante o processo de criação da instância EC2 para rodar o container Docker com o WordPress, é possível **automatizar toda a configuração inicial** usando o campo **User Data** ao lançar a instância.

Isso elimina a necessidade de acessar manualmente a instância para instalar Docker e rodar o container. Abaixo está um exemplo funcional de script `User Data`, baseado exatamente no que foi usado neste projeto:
```bash
#!/bin/bash
apt update -y
apt upgrade -y
apt install -y docker.io nfs-common

mkdir -p /mnt/efs
mount -t nfs4 -o nfsvers=4.1 fs-<ID-DO-EFS>.efs.us-east-1.amazonaws.com:/ /mnt/efs

cd /home/ubuntu/

cat > docker-compose.yml <<EOF
services:
  wordpress:
    image: wordpress:latest
    ports:
      - 80:80
    environment:
      WORDPRESS_DB_HOST: <ENDERECO-DO-RDS>
      WORDPRESS_DB_USER: admin
      WORDPRESS_DB_PASSWORD: <SENHA-DO-RDS>
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - /mnt/efs:/var/www/html
EOF

docker compose up -d
```

- Conectar via bastion
- Instalar Docker e Docker Compose
- Montar o EFS em /mnt/efs:
```bash
sudo mount -t nfs4 -o nfsvers=4.1 fs-xxxxxxxx.efs.us-east-1.amazonaws.com:/ /mnt/efs
```
- Criar `docker-compose.yml` para WordPress:
```yaml
services:
  wordpress:
    image: wordpress:latest
    ports:
      - 80:80
    environment:
      WORDPRESS_DB_HOST: <endpoint do RDS>
      WORDPRESS_DB_USER: <usuario>
      WORDPRESS_DB_PASSWORD: <senha>
      WORDPRESS_DB_NAME: <nome do banco>
    volumes:
      - /mnt/efs:/var/www/html
```
- Rodar:
```bash
sudo docker compose up -d
```

### 6. Target Group
- Tipo: IP
- Porta: 80
- VPC correta
- Adicionar IPs privados das instâncias
- Health Check: path `/`, protocolo HTTP

### 7. Application Load Balancer
- Tipo: Internet-facing
- Subnets públicas
- SG: SG-ALB
- Listener: porta 80 → encaminhar para o target group
- Acesso: `http://<DNS do ALB>`

### 8. Auto Scaling Group
- Criar Launch Template com:
  - AMI Ubuntu
  - Subnet privada
  - SG-EC2
  - Script de inicialização para instalar Docker, montar EFS e iniciar WordPress
- Criar Auto Scaling Group:
  - Subnets privadas
  - Associar ao Target Group
  - Definir min/max de instâncias
  - Política de escalabilidade com base na CPU

---


## 🧰 Tecnologias Utilizadas

- AWS EC2, VPC, RDS, EFS, ALB, Auto Scaling
- Docker & Docker Compose
- Ubuntu Server 24.04
- WordPress

## Autor

👤 **Lucas Gomes Fagundes**  
Apaixonado por tecnologia e sempre buscando aprimorar habilidades em ambientes reais de desenvolvimento e implantação.

[LinkedIn]([https://www.linkedin.com](https://www.linkedin.com/in/lucas-gomes-fagundes-478b742b4/)) 

