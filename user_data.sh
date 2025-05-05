#!/bin/bash
apt update
apt install -y docker.io docker-compose nfs-common
systemctl enable docker
systemctl start docker

mkdir -p /mnt/efs
mount -t nfs4 -o nfsvers=4.1 fs-<ID-DO-EFS>.efs.us-east-1.amazonaws.com:/ /mnt/efs
chown -R 33:33 /mnt/efs

cd /home/ubuntu

cat <<EOF > docker-compose.yml
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
      - /mnt/efs/wp-content:/var/www/html/wp-content
    restart: always
EOF

docker compose up -d
