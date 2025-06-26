#!/bin/bash

README="README.md"

echo "📄 Atualizando $README..."

cat > "$README" << 'EOF'
# Biotrónica

A integração controlada entre backend Node.js moderno e um frontend CMS estático (Archivarix) para gerir conteúdos científicos e terapêuticos, com autenticação, API REST, gestão de listas e futura integração com programas como qWELLNESS, miniVOLL, scriptIMPORTER e ionZAPPER.

---

## 📚 Descrição completa

**Biotrónica** é um projeto que une um backend moderno em **NestJS/Node.js** com um frontend estático gerado com **Archivarix CMS**, oferecendo uma plataforma híbrida para gerir dados, imagens e sessões de terapias.

O backend fornece:

- 🧠 API REST modular para dados de **atlas**, **eap**, **eav** e **iontophoresis**.
- 🔐 Sistema de login com autenticação JWT.
- 🌍 Multi-idioma com prioridade em EN e PL (PT no futuro).
- 🧪 Testes integrados e cobertura de endpoints.
- 📦 Integração com MongoDB e Redis.
- 🐳 Contêineres Docker para deploy imediato.

Além disso, prepara-se para integrar ferramentas externas como:

- 🧬 `qWELLNESS`
- 💉 `miniVOLL`
- 📥 `scriptIMPORTER`, `downloader`
- 💡 `freePEMF`, `ionZAPPER`

Com suporte futuro para importação automática de imagens e dados clínicos para terapias alternativas.

---

## 🚀 Objetivos principais

- Criar um ambiente modular, leve e escalável para gerir terapias.
- Suportar importação de dados de equipamentos e software médico complementar.
- Oferecer uma interface segura e multiusuário para edição e consulta de informações científicas.

---

## 🤝 Licença

Atualmente sem licença oficial. Para fins educacionais e testes apenas.
EOF

echo "✅ $README atualizado."

echo "📦 Enviando alterações para o Git..."

git add "$README"
git commit -m "Atualiza README com descrição curta e longa"
git push origin main

echo "🚀 Alterações enviadas com sucesso!"
