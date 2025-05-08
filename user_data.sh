#!/bin/bash
EFS_FILE_SYSTEM_ID="INSIRA O ID DO EFS AQUI"
REGION="INSIRA A REGIAO DO SEU EFS AQUI"
DB_HOST="INSIRA AQUI O ENDPOINT DO SEU RDS"
DB_NAME="INSIRA AQUI O NOME DO SEU DB"
DB_USER="INSIRA AQUI O USUARIO DO SEU DB"
DB_PASSWORD="INSIRA A SENHA DO SEU DB AQUI"
PROJECT_DIR="/root/projeto-docker-aws"
EFS_MOUNT_DIR="/mnt/efs"

apt update -y
apt install -y docker.io docker-compose nfs-common curl
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu

mkdir -p ${EFS_MOUNT_DIR}
mount -t nfs4 -o nfsvers=4.1 ${EFS_FILE_SYSTEM_ID}.efs.${REGION}.amazonaws.com:/ ${EFS_MOUNT_DIR}
echo "${EFS_FILE_SYSTEM_ID}.efs.${REGION}.amazonaws.com:/ ${EFS_MOUNT_DIR} nfs4 defaults,_netdev 0 0" >> /etc/fstab

chown -R 33:33 ${EFS_MOUNT_DIR}

mkdir -p ${PROJECT_DIR}
cd ${PROJECT_DIR}

cat > docker-compose.yml <<EOL
services:
  wordpress:
    image: wordpress:latest
    container_name: wordpress
    environment:
      WORDPRESS_DB_HOST: ${DB_HOST}
      WORDPRESS_DB_NAME: ${DB_NAME}
      WORDPRESS_DB_USER: ${DB_USER}
      WORDPRESS_DB_PASSWORD: ${DB_PASSWORD}
    ports:
      - 80:80
    volumes:
      - ${EFS_MOUNT_DIR}:/var/www/html/wp-content
    restart: always
EOL

docker-compose up -d > /var/log/docker-up.log 2>&1

