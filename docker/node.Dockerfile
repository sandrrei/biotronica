#### node.Dockerfile
# This Dockerfile sets up a Node.js environment with MongoDB shell client and utilities.
# It is designed to run a Node.js application that interacts with MongoDB.
# The application is built using npm and listens on port 3000.
# The MongoDB shell client and utilities are installed to allow interaction with MongoDB databases.
# The Node.js version used is 20, and the working directory is set to /usr/src/app.

FROM node:20

WORKDIR /usr/src/app
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl inetutils-ping cron traceroute net-tools acl \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Import MongoDB GPG key
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg

# Add MongoDB repository
RUN echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Install MongoDB Shell
RUN apt-get update && apt-get install -y --no-install-recommends mongodb-mongosh netcat-openbsd nano \
    && rm -rf /var/lib/apt/lists/*

# Optional: Clean up unnecessary files
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Instala dependências Node.js
COPY package*.json ./
RUN npm install

# Copia código e compila a aplicação
COPY . .
RUN npm run build

# Copia o script de permissões para o container
COPY ./docker/fix-permissions.sh /usr/local/bin/fix-permissions.sh

# Torna o script executável
RUN chmod +x /usr/local/bin/fix-permissions.sh

# Cria ficheiro de log para o cron
RUN touch /var/log/cron.log

# Configura cronjob para correr o script todos os dias às 3h da manhã
RUN echo "0 3 * * * root /usr/local/bin/fix-permissions.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/fix-perms \
 && chmod 0644 /etc/cron.d/fix-perms \
 && crontab /etc/cron.d/fix-perms

# Arranque do container: cron + aplicação
CMD cron && npm run start:prod

EXPOSE 3000
