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

![Captura de tela 2025-05-02 090027](https://github.com/user-attachments/assets/08498d26-644b-440c-922a-898a3f56686d)

![Captura de tela 2025-05-02 090046](https://github.com/user-attachments/assets/19a518fe-fda4-4d23-bf82-f658afc59d94)

- **EC2-SG**: Permitir entrada nas portas 80, 22 e 2049.
  
![Captura de tela 2025-05-02 090541](https://github.com/user-attachments/assets/3045c871-74f3-4926-8025-739812a237f0)

- **ALB-SG**: Permitir entrada na porta 80 de qualquer origem.

![Captura de tela 2025-05-02 090729](https://github.com/user-attachments/assets/3bd12a20-5174-483a-935a-5ac07fc990d4)

- **RDS-SG**: Permitir entrada na porta 3306 apenas do EC2-SG.

![Captura de tela 2025-05-02 090858](https://github.com/user-attachments/assets/5594cf58-8688-4c57-a1ba-7c7ca71f739c)
  
- **EFS-SG**: Permitir entrada na porta 2049 do EC2-SG.

![Captura de tela 2025-05-02 092331](https://github.com/user-attachments/assets/442107c4-1d33-4a28-aed0-69d141f1a53d)

**EC2-SG**: Atualizado com fonte dos Security Group do ALB e EFS.

![Captura de tela 2025-05-02 092457](https://github.com/user-attachments/assets/c41e2c4f-4ae6-4d3e-91cb-0b8dc0b2f509)


### 3. Banco de Dados (RDS)

![Captura de tela 2025-05-02 092602](https://github.com/user-attachments/assets/0a5385d8-de0b-4f5c-b6f5-352fe769b52c)

![Captura de tela 2025-05-02 093109](https://github.com/user-attachments/assets/74789581-d8e1-4f2e-9793-7cbd614fe53a)

- Engine: MySQL 8.x

![Captura de tela 2025-05-02 093149](https://github.com/user-attachments/assets/095acfa6-fa0f-459b-a5f7-b55ba409ab6a)

![Captura de tela 2025-05-02 093317](https://github.com/user-attachments/assets/dc047040-487f-44ca-a18b-03cd0f76139d)

- Credenciais: definir nome do DB, usuário e senha

![Captura de tela 2025-05-02 093415](https://github.com/user-attachments/assets/5b5ae32f-f563-4647-aaa1-b8304dc2639e)

- Definindo o t3.micro e o espaço utilizável
  
![Captura de tela 2025-05-02 093512](https://github.com/user-attachments/assets/528ca29e-8983-4bcb-a783-2a835405e24f)

- VPC: usar subnets privadas
- SG: usar RDS-SG

![Captura de tela 2025-05-02 093807](https://github.com/user-attachments/assets/51516550-79d1-4606-9ad6-966f3284f95f)

- Nome inicial do banco de dados

![Captura de tela 2025-05-02 093953](https://github.com/user-attachments/assets/cf26b0c2-fc4b-4403-9607-961fe8a75cec)

![Captura de tela 2025-05-02 094020](https://github.com/user-attachments/assets/b3337215-3587-4bf3-b525-c1f7a2635884)

- Espere o Banco de Dados ficar disponível.

![Captura de tela 2025-05-02 095255](https://github.com/user-attachments/assets/4966bc8d-ecf5-4976-ace6-29692077ccce)

### 4. EFS (Elastic File System)

![Captura de tela 2025-05-02 095420](https://github.com/user-attachments/assets/4bf7310b-9fe1-42f3-b92b-e804d6c31da1)

![Captura de tela 2025-05-02 095520](https://github.com/user-attachments/assets/10f2d35e-61ef-4e8f-99d6-67d41716d3e9)

![Captura de tela 2025-05-02 095548](https://github.com/user-attachments/assets/20f7ef80-1c11-43b9-bcbd-c283e581e32c)

- Criar sistema de arquivos com ponto de montagem em subnets privadas
- Associar o EFS-SG
  
![Captura de tela 2025-05-02 095702](https://github.com/user-attachments/assets/7aead517-5b68-4f21-96bc-2d95da77636f)

- Configurar a performance do EFS

![Captura de tela 2025-05-02 095911](https://github.com/user-attachments/assets/dac1f8ec-e00f-40b4-8aae-f737527b2877)

- Use as KMS Keys padrões da AWS

![Captura de tela 2025-05-02 100810](https://github.com/user-attachments/assets/ef5e1709-a141-43d5-b9ac-60e50a520fac)

![Captura de tela 2025-05-02 100818](https://github.com/user-attachments/assets/223c88a9-ff2b-4f2f-9540-671b4c0103a5)

- Espere o EFS ficar disponível

![Captura de tela 2025-05-02 101147](https://github.com/user-attachments/assets/3847f754-514d-4898-9af2-4ebd36d95bbd)

### 5. EC2 Privada com Docker

![Captura de tela 2025-05-02 101154](https://github.com/user-attachments/assets/184f0bdc-651d-498c-b51b-06258a2a3f0b)

- AMI: Ubuntu 24.04

![Captura de tela 2025-05-02 105231](https://github.com/user-attachments/assets/fe4b4611-fd3f-4c0e-a797-a239fec4fdf4)

- Criar a Key pair

![Captura de tela 2025-05-02 105430](https://github.com/user-attachments/assets/04a3bac2-a95b-4310-84d8-938deb86cdcb)

- Subnet: Privada
- SG: EC2-SG

![Captura de tela 2025-05-02 105622](https://github.com/user-attachments/assets/1641a27d-c04a-4e81-9f5e-5c332a63e897)

## Observação extra sobre EC2 e automação com User Data

Durante o processo de criação da instância EC2 para rodar o container Docker com o WordPress, é possível **automatizar toda a configuração inicial** usando o campo **User Data** ao lançar a instância.

Isso elimina a necessidade de acessar manualmente a instância para instalar Docker e rodar o container. Abaixo está um exemplo funcional de script `User Data`, baseado exatamente no que foi usado neste projeto:
```bash
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
```

- Conectar via bastion (Uma EC2 na subnet pública que consegue acessar a EC2 na subnet privada

![Captura de tela 2025-05-02 111244](https://github.com/user-attachments/assets/f5230e16-c7e0-41ba-9cf4-1acc6b1b1b64)

![Captura de tela 2025-05-02 111934](https://github.com/user-attachments/assets/8a7443fe-9847-4194-8b23-6abcb11c2e9a)

- Instalar Docker, Docker Compose e NFS
```bash
sudo apt update
sudo apt install -y docker.io docker-compose nfs-common
sudo systemctl enable docker
sudo systemctl start docker
```
- Montar o EFS em /mnt/efs:
```bash
sudo mkdir /mnt/efs
sudo mount -t nfs4 -o nfsvers=4.1 fs-xxxxxxxx.efs.us-east-1.amazonaws.com:/ /mnt/efs
sudo chown -R 33:33 /mnt/efs
```
- Criar `docker-compose.yml` para WordPress:
```bash
nano docker-compose.yml
```
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
    restart: always
```
- Rodar:
```bash
sudo docker compose up -d
```

### 6. Target Group

![Captura de tela 2025-05-02 114231](https://github.com/user-attachments/assets/744878f8-02b7-429b-b54f-d539a2e19fef)

- Tipo: Instances
- Porta: 80

![Captura de tela 2025-05-02 114352](https://github.com/user-attachments/assets/a925faa2-459b-48c0-8265-45c617db69e7)

- VPC correta

![Captura de tela 2025-05-02 114405](https://github.com/user-attachments/assets/a45c29ce-6e4b-4264-88f6-544e19ba2a3d)

- Registre os targets

![Captura de tela 2025-05-02 114549](https://github.com/user-attachments/assets/977f368b-0611-46bd-8904-4708643447ad)

![Captura de tela 2025-05-02 114518](https://github.com/user-attachments/assets/89448832-aef1-4b8a-8ebc-8f9a95e3eb32)

### 7. Application Load Balancer

![Captura de tela 2025-05-02 114826](https://github.com/user-attachments/assets/13833c0a-6cf1-46e0-a28b-2950b42bd7d0)

![Captura de tela 2025-05-02 114836](https://github.com/user-attachments/assets/cd8459cd-78c4-4f1e-b92f-4ead34d1c1d7)

- Subnets públicas

![Captura de tela 2025-05-02 115003](https://github.com/user-attachments/assets/c3cc1277-d8a8-4d6a-bf0b-0abf22056aa0)

- Acesso:

![Captura de tela 2025-05-02 115615](https://github.com/user-attachments/assets/2229a551-2e13-452c-bc7b-3d8787eb7de3)

- Aplicação Rodando:

![Captura de tela 2025-05-02 122221](https://github.com/user-attachments/assets/9e1c38c6-b2ea-45c4-b4ae-a2827cef1ca0)

### 8. Auto Scaling Group

![Captura de tela 2025-05-02 125136](https://github.com/user-attachments/assets/308b0f97-2b41-47c0-9436-159093901690)

![Captura de tela 2025-05-02 125143](https://github.com/user-attachments/assets/83f49cbe-5cab-4a81-83c5-1c0eea157ba4)

![Captura de tela 2025-05-02 125208](https://github.com/user-attachments/assets/eb6a362b-59ee-487c-8432-ff576735fa74)

- Criar Launch Template com:
  - AMI Ubuntu
  - Subnet privada
  - EC2-SG
  - Script de inicialização para instalar Docker, montar EFS e iniciar WordPress
    
- Criar Auto Scaling Group:
  - Subnets privadas
    
![Captura de tela 2025-05-02 130418](https://github.com/user-attachments/assets/c945ca70-889d-4f2c-b78d-41d223cea543)

  - Associar ao Target Group

![Captura de tela 2025-05-02 130502](https://github.com/user-attachments/assets/5374aa8c-f05a-4a64-8555-fc170b4cd71b)

  - Definir min/max de instâncias
  - Política de escalabilidade com base na CPU

![Captura de tela 2025-05-02 130656](https://github.com/user-attachments/assets/2e1d7488-4a67-4460-9163-9d3df8e01331)

- Auto-Scaling adicionando EC2 na infra:

![Captura de tela 2025-05-02 130922](https://github.com/user-attachments/assets/578f7707-0651-4291-bcc2-23f3129d6a69)

- Wordpress funcionando normalmente:

![Captura de tela 2025-05-02 132421](https://github.com/user-attachments/assets/a0f84567-20bf-46e3-9003-89d222359443)

---


## 🧰 Tecnologias Utilizadas

- AWS EC2, VPC, RDS, EFS, ALB, Auto Scaling
- Docker & Docker Compose
- Ubuntu Server 24.04
- WordPress

## Autor

👤 **Lucas Gomes Fagundes**  
Apaixonado por tecnologia e sempre buscando aprimorar habilidades em ambientes reais de desenvolvimento e implantação.

https://www.linkedin.com/in/lucas-gomes-fagundes-478b742b4/

