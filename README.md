# 🚀 Deploy de Aplicação Java em Docker usando Jenkins na AWS

![AWS](https://imgur.com/Hk28ffE.png)

## 📌 Sobre o Projeto

Este projeto demonstra a implementação de um pipeline completo de CI/CD para uma aplicação Java Web, utilizando Jenkins para build automatizado com Maven e Docker para containerização, tudo provisionado em instâncias EC2 na AWS.

A solução simula um cenário real de DevOps, onde cada commit no repositório dispara automaticamente o processo de build, geração de artefato (.war), criação da imagem Docker e deploy do container em ambiente remoto.

---

# 🎯 Objetivo Técnico

Construir um pipeline automatizado capaz de:

- Integrar código versionado no GitHub
- Compilar aplicação Java com Maven
- Gerar artefato .war
- Transferir artefato para servidor Docker
- Criar imagem Docker customizada
- Subir container automaticamente
- Validar deploy via navegador

---

# 🏗️ Arquitetura da Solução

A arquitetura é composta por dois servidores EC2:

## 🔹 Jenkins Server (CI)
- Amazon Linux EC2
- Java OpenJDK 11
- Jenkins
- Maven
- Git
- Plugin Publish Over SSH

## 🔹 Docker Host (CD)
- Amazon Linux EC2
- Docker Engine
- Tomcat Container
- Imagem customizada com Dockerfile

Fluxo do pipeline:

GitHub → Jenkins Build → Artifact (.war) → SSH → Docker Host → Build Image → Run Container

---

# 🧰 Stack Tecnológica

- AWS EC2
- Jenkins
- GitHub
- Maven
- Docker
- Apache Tomcat
- Java OpenJDK 11
- SSH
- Linux CLI

---

# 🚀 Etapas de Implementação

---

# 🔹 1. Setup do Jenkins na AWS

### Provisionamento

- Criar instância EC2 (t2.micro)
- Liberar portas:
  - 22 (SSH)
  - 8080 (Jenkins)
- Instalar:
  - Java 11
  - Jenkins
  - Git
  - Maven

### Inicialização

- Iniciar serviço Jenkins
- Acessar via: `http://<public-ip>:8080`
- Recuperar senha inicial em:
  ```
  /var/lib/jenkins/secrets/initialAdminPassword
  ```
- Instalar plugins sugeridos
- Criar usuário administrador

---

# 🔹 2. Integração GitHub + Maven

### Configurações

- Instalar Git no servidor
- Instalar GitHub Integration Plugin
- Configurar Git em Global Tool Configuration
- Instalar Maven Integration Plugin
- Configurar JAVA_HOME e M2_HOME

Resultado:

✔ Jenkins apto a clonar repositório  
✔ Build automatizado via Maven  
✔ Geração de arquivo .war  

---

# 🔹 3. Setup do Docker Host

Criar segunda instância EC2:

- Instalar Docker
- Habilitar e iniciar serviço
- Liberar portas 8081–9000 no Security Group

---

# 🔹 4. Resolução do Problema do Tomcat Oficial

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

# 🔹 5. Integração Docker com Jenkins

### Configurações

- Criar usuário `dockeradmin`
- Adicionar ao grupo docker
- Habilitar autenticação SSH
- Instalar plugin Publish Over SSH
- Configurar Docker Host em "Configure System"

Resultado:

✔ Jenkins conectado ao Docker Host  
✔ Capaz de enviar artefatos remotamente  

---

# 🔹 6. Build e Transferência do Artefato

No Jenkins:

- Criar novo job
- Configurar SCM (GitHub)
- Configurar build Maven
- Em Post-Build:
  - Send files over SSH
  - Enviar arquivo `.war` para `/opt/docker`

Validação:

✔ Arquivo webapp.war presente no Docker Host  

---

# 🔹 7. Atualização do Dockerfile para Deploy da Aplicação

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

# 🔹 8. Automação Completa (CI/CD)

Comandos adicionados no campo Exec do Jenkins:

```
cd /opt/docker;
docker build -t regapp:v1 .;
docker run -d --name registerapp -p 8087:8080 regapp:v1
```

Fluxo final:

1. Commit no GitHub  
2. Jenkins dispara build automaticamente  
3. Maven gera WAR  
4. WAR enviado via SSH  
5. Docker build executado remotamente  
6. Novo container sobe automaticamente  

Deploy acessível via:

```
http://<public-ip>:8087/webapp/
```

✔ Pipeline totalmente automatizado  

---

# 🔐 Boas Práticas Aplicadas

- Separação de responsabilidades (CI / CD)
- Uso de Dockerfile customizado
- Build automatizado via SCM polling
- Integração segura via SSH
- Containerização para portabilidade
- Automação end-to-end

---

# 📊 Resultados Técnicos

✔ Pipeline CI/CD funcional  
✔ Deploy automatizado  
✔ Containerização da aplicação  
✔ Integração completa AWS + Jenkins + Docker  
✔ Processo replicável e escalável  

---

# 📚 Aprendizados Estratégicos

- Jenkins como orquestrador de CI/CD
- Build Java com Maven
- Containerização de aplicações tradicionais
- Deploy remoto via SSH
- Automação baseada em eventos (commit)

---

# ⭐ Se este projeto foi útil

Considere:

- Dar uma estrela ⭐  
- Compartilhar com sua rede  
- Adaptar para pipeline declarativo  
- Transformar em projeto Terraform + CI/CD  

---

> Projeto prático de CI/CD demonstrando integração real entre GitHub, Jenkins, Docker e AWS.
