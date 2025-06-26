#### limpar-e-preparar.sh
#
#Este script automatiza a limpeza e organização do repositório Git, gerando `.gitignore` e `README.md`, removendo ficheiros ignorados do índice, e opcionalmente realizando `git commit + push`:
#
#```bash
#!/bin/bash

#!/bin/bash

set -e

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

# Archivarix
html/.content.*
html/sessions/

# Backups / Temporários
.DS_Store
*.swp
*.swo
node-backend-*/
*.sqlite
*.zip
EOF

echo "✅ .gitignore atualizado."

echo "🧹 Limpando arquivos ignorados do índice Git..."

# Remove do índice (mas mantém no disco)
git rm -r --cached node_modules dist html/.content.* html/sessions/ node-backend-* docker/.git .env 2>/dev/null || true

echo "✅ Remoções concluídas (se existiam)."

echo "📦 Preparando arquivos úteis..."

git add .gitignore \
        html/index.php \
        scripts/ \
        docker/ \
        .dockerignore

echo "🛠 Gerando README.md automaticamente..."

cat > README.md <<'EOF'
# Biotronica 🧠⚡

Este projeto combina uma API moderna construída em [NestJS](https://nestjs.com) com um frontend estático via [Archivarix CMS](https://archivarix.com/en/restore/), orientado para dados bioeletrônicos e terapias.

---

## 🚀 Funcionalidades

- API NestJS com autenticação (JWT)
- Módulos de dados: `eap`, `eav`, `atlas`, `iontophoresis`
- Sistema de fóruns
- Armazenamento MongoDB + Redis
- Frontend estático em PHP/HTML (Archivarix)
- Docker Compose para desenvolvimento

---

## 📁 Estrutura

```
├── data/          # Ficheiros .txt com dados brutos
├── docker/        # Dockerfiles (Node.js e PHP)
├── html/          # Frontend CMS (Archivarix)
├── src/           # Código fonte NestJS
├── dist/          # Build de produção NestJS
└── scripts/       # Scripts de manutenção como este
```

---

## 🏗️ Como iniciar

```bash
cd docker
docker compose up
```

🧪 Testes:

```bash
npm run test
```

📝 Observações:

- Para editar o frontend, use o editor da Archivarix.
- Para dados JSON/TXT, veja a pasta `/data`.
- A autenticação é necessária para operações de escrita (CRUD).

📦 Docker:

```bash
cd docker
docker compose up         # Iniciar
docker compose down       # Parar
```

🧠 Contribuições:

Pull requests são bem-vindos!  
Este projeto é mantido por @sandrrei 💚
EOF

git add README.md
echo "✅ README.md criado e incluído no commit."

echo
echo "🔍 Verificando alterações pendentes..."
git status

echo
read -p "👉 Deseja confirmar e fazer commit? (s/n): " confirm
if [[ "$confirm" == "s" ]]; then
  git commit -m "Limpeza e geração automática do README.md"
  echo "✅ Commit criado."

  read -p "🚀 Deseja fazer push para o GitHub agora? (s/n): " push_confirm
  if [[ "$push_confirm" == "s" ]]; then
    git push origin main
    echo "🚀 Alterações enviadas para o GitHub!"
  else
    echo "📦 Push adiado. Podes fazer manualmente com: git push"
  fi
else
  echo "❌ Cancelado. Nada foi enviado."
fi
```
