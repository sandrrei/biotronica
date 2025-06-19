#!/bin/bash

BASE="/home/sandrrei/biotronica-backup/biotronica"
REPO_DIR="$BASE/backup-git"

# Clona o repositório de backup (ou atualiza se já existir)
if [ ! -d "$REPO_DIR" ]; then
    git clone https://github.com/sandrrei/biotronica.git "$REPO_DIR"
else
    cd "$REPO_DIR" && git pull origin main
fi

# Copia os dados que queremos versionar para o repo local
rsync -a --delete "$BASE/html/" "$REPO_DIR/html/"
rsync -a --delete "$BASE/docker/" "$REPO_DIR/docker/"

cd "$REPO_DIR" || exit

# Ignorar arquivos temporários e grandes
cat > .gitignore << EOF
code-server-data/
sessions/
*.log
*.sqlite
*.zip
EOF

# Adiciona alterações, commit e push
git add .
git commit -m "Backup completo em $(date '+%Y-%m-%d %H:%M:%S')" || echo "Nenhuma alteração para commitar"
git push origin master
