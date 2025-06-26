#!/bin/bash

BACKUP_DIR="/mnt/backup-ssd/mongodb-dump"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="backup_${TIMESTAMP}.archive"

echo "📦 A fazer backup da base de dados MongoDB para ${BACKUP_DIR}/${FILENAME}..."

# Faz o dump dentro do container
docker exec todo-playground-mongo mongodump --archive=/data/${FILENAME}

# Copia do container para o host
docker cp todo-playground-mongo:/data/${FILENAME} ${BACKUP_DIR}/${FILENAME}

# Apaga o dump do container (opcional)
docker exec todo-playground-mongo rm /data/${FILENAME}

echo "✅ Backup MongoDB concluído!"