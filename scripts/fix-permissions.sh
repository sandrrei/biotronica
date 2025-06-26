#!/bin/bash

TARGET="/media/md127/biotronica/html"

echo "⚙️  Corrigindo permissões em: $TARGET"

# 1. Corrigir o dono (recursivamente)
echo "📦 Corrigindo dono para www-data:www-data..."
sudo chown -R www-data:www-data "$TARGET"

# 2. Corrigir permissões básicas
echo "🔧 Corrigindo permissões base..."
sudo find "$TARGET" -type d -exec chmod 2775 {} \;
sudo find "$TARGET" -type f -exec chmod 664 {} \;

# 3. Ativar ACLs (caso ainda não estejam)
echo "🔐 Aplicando ACLs para www-data..."
sudo setfacl -R -m u:www-data:rwX "$TARGET"
sudo setfacl -R -m d:u:www-data:rwX "$TARGET"

# 4. Permitir que user 1000 também continue com acesso total (VSCode)
echo "👤 Garantindo acesso ao utilizador 1000..."
sudo setfacl -R -m u:1000:rwX "$TARGET"
sudo setfacl -R -m d:u:1000:rwX "$TARGET"

echo "✅ Permissões corrigidas com sucesso!"
