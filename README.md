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

