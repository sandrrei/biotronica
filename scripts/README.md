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

├── data/ # Ficheiros .txt com dados brutos
├── docker/ # Dockerfiles (Node.js e PHP)
├── html/ # Frontend CMS (Archivarix)
├── src/ # Código fonte NestJS (modular)
├── dist/ # Build de produção NestJS
└── scripts/ # Scripts de manutenção como este


---

## 🏗️ Como iniciar

```bash
cd docker
docker compose up


🧪 Testes
bash
Copy
Edit
npm run test
📝 Observações
Para editar o frontend, use o editor da Archivarix.

Para dados JSON/TXT, veja a pasta /data.

A autenticação é necessária para operações de escrita (CRUD).

📦 Docker
bash
Copy
Edit
cd docker
docker compose up         # Iniciar
docker compose down       # Parar
🧠 Contribuições
Pull requests são bem-vindos!
Este projeto é mantido por @sandrrei 💚

