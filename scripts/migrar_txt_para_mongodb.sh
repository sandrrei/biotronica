#!/bin/bash

# Caminhos
DATA_DIR="/home/sandrrei/biotronica/data"
BACKUP_DIR="/mnt/backup-ssd/data-backup-$(date +%Y%m%d_%H%M%S)"
MONGO_CONTAINER="todo-playground-mongo"
DATABASE="nestjs-todo-playground"

# Lista de coleções e ficheiros
FILES=("ion" "atlas" "eav" "eap")

echo "📁 A criar backup dos ficheiros para $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"
cp "$DATA_DIR"/*.txt "$BACKUP_DIR/"
echo "✅ Backup concluído."

# Importar para MongoDB dentro do container
for FILE in "${FILES[@]}"; do
  echo "➡️ A importar $FILE.txt para MongoDB..."
  docker exec -i "$MONGO_CONTAINER" \
    mongoimport --db "$DATABASE" --collection "$FILE" \
    --type json --file "/data/$FILE.txt" --jsonArray
done

echo "✅ Migração para MongoDB concluída."
