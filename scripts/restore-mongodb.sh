#!/bin/bash

# Caminho do backup
BACKUP_DIR="/mnt/backup-ssd/mongodb-dump"
CONTAINER_NAME="todo-playground-mongo"
DB_NAME="nestjs-todo-playground"

# Encontrar o ficheiro .archive mais recente
LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/*.archive 2>/dev/null | head -n 1)

if [[ -z "$LATEST_BACKUP" ]]; then
  echo "❌ Nenhum ficheiro de backup .archive encontrado em $BACKUP_DIR"
  exit 1
fi

echo "🔄 A restaurar MongoDB a partir de $LATEST_BACKUP..."

# Executar o comando dentro do container
docker cp "$LATEST_BACKUP" "$CONTAINER_NAME":/data/restore.archive

docker exec -i "$CONTAINER_NAME" mongorestore \
  --archive=/data/restore.archive \
  --drop

RESTORE_STATUS=$?

# Limpar arquivo temporário
docker exec "$CONTAINER_NAME" rm -f /data/restore.archive

if [[ $RESTORE_STATUS -eq 0 ]]; then
  echo "✅ Restauração concluída com sucesso!"
else
  echo "❌ Erro durante a restauração!"
  exit 1
fi
