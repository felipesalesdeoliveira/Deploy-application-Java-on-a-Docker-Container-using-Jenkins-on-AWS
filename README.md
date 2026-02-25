# 🚀 Deploy de Aplicação Java em Docker usando Jenkins + Terraform na AWS

![AWS](https://imgur.com/Hk28ffE.png)

## 📌 Sobre o Projeto

Este projeto demonstra a implementação de um pipeline completo de CI/CD para uma aplicação Java Web, utilizando Jenkins para build automatizado com Maven, Docker para containerização e **Terraform para provisionamento da infraestrutura como código (IaC)** na AWS.

A solução simula um cenário real de DevOps, onde:

* A infraestrutura é criada automaticamente via Terraform
* Cada commit no repositório dispara o processo de build
* O artefato (.war) é gerado
* A imagem Docker é criada
* O deploy é realizado automaticamente em ambiente provisionado na AWS

---

# 🎯 Objetivo Técnico

Construir uma solução automatizada capaz de:

* Provisionar infraestrutura na AWS com Terraform
* Integrar código versionado no GitHub
* Compilar aplicação Java com Maven
* Gerar artefato .war
* Transferir artefato para servidor Docker
* Criar imagem Docker customizada
* Subir container automaticamente
* Validar deploy via navegador

---

# 🏗️ Arquitetura da Solução

A arquitetura é composta por infraestrutura provisionada via Terraform:

## 🔹 Camada de Infraestrutura (IaC)

* VPC
* Subnets públicas
* Internet Gateway
* Security Groups
* 2 Instâncias EC2

## 🔹 Jenkins Server (CI)

* Amazon Linux EC2
* Java OpenJDK 11
* Jenkins
* Maven
* Git
* Plugin Publish Over SSH

## 🔹 Docker Host (CD)

* Amazon Linux EC2
* Docker Engine
* Tomcat Container
* Imagem customizada com Dockerfile

Fluxo completo:

Terraform → AWS Infra → GitHub → Jenkins Build → Artifact (.war) → SSH → Docker Host → Build Image → Run Container

---

# 🧰 Stack Tecnológica

* AWS EC2
* Terraform
* Jenkins
* GitHub
* Maven
* Docker
* Apache Tomcat
* Java OpenJDK 11
* SSH
* Linux CLI

---

# 🚀 Etapas de Implementação

---

# 🔹 1. Provisionamento com Terraform (IaC)

### Estrutura

* provider.tf
* main.tf
* variables.tf
* outputs.tf

### Recursos Criados

* VPC
* Subnet pública
* Internet Gateway
* Route Table
* Security Groups
* EC2 Jenkins
* EC2 Docker Host

### Execução

```bash
terraform init
terraform plan
terraform apply
```

Resultado:

✔ Infraestrutura criada automaticamente
✔ EC2 Jenkins provisionada
✔ EC2 Docker Host provisionada

---

# 🔹 2. Setup do Jenkins na AWS

### Provisionamento (já criado via Terraform)

* Instância EC2 (t2.micro)
* Portas liberadas:

  * 22 (SSH)
  * 8080 (Jenkins)

### Instalação

* Java 11
* Jenkins
* Git
* Maven

### Inicialização

* Iniciar serviço Jenkins
* Acessar via: `http://<public-ip>:8080`
* Recuperar senha inicial em:

  ```
  /var/lib/jenkins/secrets/initialAdminPassword
  ```
* Instalar plugins sugeridos
* Criar usuário administrador

---

# 🔹 3. Integração GitHub + Maven

### Configurações

* Instalar Git no servidor
* Instalar GitHub Integration Plugin
* Configurar Git em Global Tool Configuration
* Instalar Maven Integration Plugin
* Configurar JAVA_HOME e M2_HOME

Resultado:

✔ Jenkins apto a clonar repositório
✔ Build automatizado via Maven
✔ Geração de arquivo .war

---

# 🔹 4. Setup do Docker Host

(Provisionado automaticamente via Terraform)

* Instalar Docker
* Habilitar e iniciar serviço
* Security Group liberando portas 8081–9000

---

# 🔹 5. Resolução do Problema do Tomcat Oficial

A imagem oficial do Tomcat possui conteúdo padrão em:

```
/webapps.dist
```

Criamos Dockerfile customizado:

```dockerfile
FROM tomcat:latest
RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps
```

Build da imagem:

```
docker build -t tomcatserver .
```

Execução do container:

```
docker run -d --name tomcat-server -p 8085:8080 tomcatserver
```

✔ Container funcional
✔ Sem erro 404

---

# 🔹 6. Integração Docker com Jenkins

### Configurações

* Criar usuário `dockeradmin`
* Adicionar ao grupo docker
* Habilitar autenticação SSH
* Instalar plugin Publish Over SSH
* Configurar Docker Host em "Configure System"

Resultado:

✔ Jenkins conectado ao Docker Host
✔ Capaz de enviar artefatos remotamente

---

# 🔹 7. Build e Transferência do Artefato

No Jenkins:

* Criar novo job
* Configurar SCM (GitHub)
* Configurar build Maven
* Em Post-Build:

  * Send files over SSH
  * Enviar arquivo `.war` para `/opt/docker`

Validação:

✔ Arquivo webapp.war presente no Docker Host

---

# 🔹 8. Atualização do Dockerfile para Deploy da Aplicação

Dockerfile final:

```dockerfile
FROM tomcat:latest
RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps
COPY ./*.war /usr/local/tomcat/webapps
```

Build da nova imagem:

```
docker build -t tomcat:v1 .
```

Executar container:

```
docker run -d --name tomcatv1 -p 8086:8080 tomcat:v1
```

Acesso:

```
http://<public-ip>:8086/webapp/
```

✔ Aplicação Java rodando em container

---

# 🔹 9. Automação Completa (CI/CD + IaC)

Comandos adicionados no campo Exec do Jenkins:

```
cd /opt/docker;
docker build -t regapp:v1 .;
docker run -d --name registerapp -p 8087:8080 regapp:v1
```

Fluxo final:

1. Terraform provisiona infraestrutura
2. Commit no GitHub
3. Jenkins dispara build automaticamente
4. Maven gera WAR
5. WAR enviado via SSH
6. Docker build executado remotamente
7. Novo container sobe automaticamente

Deploy acessível via:

```
http://<public-ip>:8087/webapp/
```

✔ Infraestrutura como Código
✔ Pipeline totalmente automatizado
✔ Deploy automatizado

---

# 🔐 Boas Práticas Aplicadas

* Infraestrutura como Código (Terraform)
* Separação de responsabilidades (IaC / CI / CD)
* Uso de Dockerfile customizado
* Build automatizado via SCM polling
* Integração segura via SSH
* Containerização para portabilidade
* Automação end-to-end

---

# 📊 Resultados Técnicos

✔ Provisionamento automatizado da infraestrutura
✔ Pipeline CI/CD funcional
✔ Deploy automatizado
✔ Containerização da aplicação
✔ Integração completa AWS + Terraform + Jenkins + Docker
✔ Processo replicável e escalável

---

# 📚 Aprendizados Estratégicos

* Terraform como ferramenta de IaC
* Jenkins como orquestrador de CI/CD
* Build Java com Maven
* Containerização de aplicações tradicionais
* Deploy remoto via SSH
* Automação baseada em eventos (commit)

---

# ⭐ Se este projeto foi útil

Considere:

* Dar uma estrela ⭐
* Compartilhar com sua rede
* Evoluir para pipeline declarativo
* Integrar com ECR e ECS futuramente

---

> Projeto prático de DevOps demonstrando integração real entre Terraform, GitHub, Jenkins, Docker e AWS.
