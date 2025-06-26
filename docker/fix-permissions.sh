#!/bin/bash
# 🚀 fix-permissions.sh – Corrige donos, permissões e ACLs no diretório do projeto

##### TARGET_DIR="/var/www/html"  # Altere conforme o container: Node/VSC pode ser /usr/src/app | neste caso não necessaria com auto detect ni if
LOG_PREFIX="[$(date '+%Y-%m-%d %H:%M:%S')]"

echo "$LOG_PREFIX ⚙️  Corrigindo permissões em: $TARGET_DIR"

# Detecta o tipo de container pela existência do diretório
if [ -d "/var/www/html" ]; then
  TARGET_DIR="/var/www/html"       # PHP container
elif [ -d "/usr/src/app" ]; then
  TARGET_DIR="/usr/src/app"        # Node container
elif [ -d "/home/coder" ]; then
  TARGET_DIR="/home/coder/project" # VSCode / code-server
else
  echo "❌ Não foi possível determinar o diretório base."
  exit 1
fi

# Define dono para www-data
echo "$LOG_PREFIX 📦 Corrigindo dono para www-data:www-data..."
chown -R www-data:www-data "$TARGET_DIR"

# Permissões seguras para arquivos e diretórios
echo "$LOG_PREFIX 🔧 Corrigindo permissões..."
find "$TARGET_DIR" -type d -exec chmod 2775 {} \;
find "$TARGET_DIR" -type f -exec chmod 664 {} \;

# Aplica ACL para www-data e para o utilizador 1000 (VSCode ou host user)
echo "$LOG_PREFIX 🔐 Aplicando ACLs para www-data e utilizador 1000..."
setfacl -R -m u:www-data:rwX "$TARGET_DIR"
setfacl -R -m u:1000:rwX "$TARGET_DIR"
setfacl -dR -m u:www-data:rwX "$TARGET_DIR"
setfacl -dR -m u:1000:rwX "$TARGET_DIR"

echo "$LOG_PREFIX ✅ Permissões corrigidas com sucesso!"
exit 0
