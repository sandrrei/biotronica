#!/bin/bash

echo "📄 Atualizando .gitignore..."

cat > .gitignore <<'EOF'
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

# Temporários
*.swp
*.swo
.DS_Store

# Archivarix
html/.content*/
html/sessions/

# Outros
node-backend-*/
EOF

echo "✅ .gitignore atualizado."

echo "🧹 Limpando arquivos ignorados do índice Git..."

# Remove do índice todos os ficheiros agora ignorados
git rm -r --cached node_modules dist html/.content.* html/sessions/ node-backend-* docker/.git 2>/dev/null

echo "✅ Remoções concluídas (se existiam)."

echo "📦 Preparando para adicionar arquivos úteis..."

# Adiciona apenas os ficheiros principais e scripts
git add .gitignore \
        README.md \
        README-backup.md \
        archivarix.cms.php \
        html/index.php \
        html/2rkgwWU2.php \
        scripts/

echo
echo "🔍 Verificando alterações pendentes..."
git status

echo
read -p "👉 Deseja confirmar e fazer commit? (s/n): " confirm
if [[ "$confirm" == "s" ]]; then
    git commit -m "Limpeza inicial: atualiza .gitignore, remove ruído e adiciona arquivos úteis"
    git push origin main
    echo "🚀 Alterações enviadas para o GitHub!"
else
    echo "❌ Cancelado. Nada foi enviado."
fi
