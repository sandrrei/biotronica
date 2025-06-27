#!/bin/bash

# Caminhos e definições
BASE="/home/sandrrei/biotronica"
REPO_DIR="$BASE/biotronica"
BACKUP_DIR="/mnt/backup-ssd/mongodb-dump"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
MONGO_FILE="backup_${TIMESTAMP}.archive"
MONGO_CONTAINER="biotronica-mongo-1"

echo "📦 A iniciar backup completo do projeto..."

# Clonar ou atualizar repositório
if [ ! -d "$REPO_DIR" ]; then
    git clone https://github.com/sandrrei/biotronica.git "$REPO_DIR"
else
    cd "$REPO_DIR" && git pull origin main
fi

# Sincronizar conteúdo importante
rsync -a --delete "$BASE/html/" "$REPO_DIR/html/"
rsync -a --delete "$BASE/docker/" "$REPO_DIR/docker/"

# Gerar ou atualizar .gitignore
cat > "$REPO_DIR/.gitignore" << EOF
# Node.js
node_modules/
dist/
*.tsbuildinfo

# NestJS
.env
*.log

# Docker
docker/*.git
docker/.dockerignore

# Archivarix
html/2rkgwWU2.php
html/.htaccess
html/.content.*
html/sessions/
html/archivarix.cms.php
user/

# Backups / Temporários
.DS_Store
*.swp
*.swo
node-backend-*/
*.sqlite
*.zip
EOF

# Backup MongoDB (via container)
echo "🧠 Backup MongoDB dentro do container..."
docker exec "$MONGO_CONTAINER" mongodump --archive=/data/"$MONGO_FILE"
docker cp "$MONGO_CONTAINER":/data/"$MONGO_FILE" "$BACKUP_DIR/$MONGO_FILE"
docker exec "$MONGO_CONTAINER" rm /data/"$MONGO_FILE"
echo "✅ MongoDB salvo em $BACKUP_DIR/$MONGO_FILE"

# Git add/commit/push
cd "$REPO_DIR" || exit
git add .
git commit -m "Backup completo em $TIMESTAMP" || echo "ℹ️ Sem alterações para commitar"
git push origin main

echo "✅ Backup completo concluído com sucesso!"
