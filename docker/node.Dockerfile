# Stage 1: Builder
FROM node:20

WORKDIR /usr/src/app

# Prevent debconf frontend warnings during apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Install MongoDB shell client and utilities
RUN curl -fsSL https://pgp.mongodb.com/server-7.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg && \
    echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/debian bullseye/mongodb-org/7.0 main" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list && \
    apt-get update && \
    apt-get install -y netcat-openbsd nano jq

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

EXPOSE 3000
CMD ["node", "dist/main"]
