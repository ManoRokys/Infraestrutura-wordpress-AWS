#!/bin/bash
# Atualiza pacotes e instala Docker + NFS
apt update -y
apt upgrade -y
apt install -y docker.io nfs-common

# Cria diretório e monta o EFS
mkdir -p /mnt/efs
mount -t nfs4 -o nfsvers=4.1 fs-<ID-DO-EFS>.efs.us-east-1.amazonaws.com:/ /mnt/efs

# Vai para o diretório do usuário padrão
cd /home/ubuntu

# Cria o arquivo docker-compose.yml diretamente
cat > docker-compose.yml <<EOF
version: '3.1'
services:
  wordpress:
    image: wordpress:latest
    ports:
      - 80:80
    environment:
      WORDPRESS_DB_HOST: <ENDERECO-DO-RDS>
      WORDPRESS_DB_USER: admin
      WORDPRESS_DB_PASSWORD: senha123
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - /mnt/efs:/var/www/html
EOF

# Sobe o container
docker compose up -d
