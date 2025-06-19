# Biotronica

Projeto open source para gestão e partilha de dados de saúde e bem-estar, que combina um backend moderno em NestJS com um frontend em PHP baseado no Archivarix CMS. O sistema suporta múltiplas línguas (atualmente Inglês e Polaco, com suporte futuro para Português) e integra vários programas externos para análise e tratamento, como qWELLNESS, miniVOLL, scriptIMPORTER, downloader, freePEMF e ionZAPPER.

---

## 🚀 Funcionalidades principais

- **Backend robusto**: desenvolvido com NestJS, MongoDB e Redis para alta performance e escalabilidade.
- **Frontend flexível**: baseado em PHP e Archivarix CMS para fácil gestão de conteúdos.
- **Sistema multilíngue**: suporte a Inglês, Polaco, e plano para Português.
- **API REST ativa**: permite integração com programas externos para upload, obtenção de imagens e tratamentos.
- **Gestão centralizada de contas**: login e permissões controladas via backend Node.js.
- **Versionamento e backups**: projeto versionado no GitHub com práticas de desenvolvimento ágil.
- **Docker**: ambiente containerizado para desenvolvimento e produção simplificados.
- **Scripts utilitários**: facilitam a limpeza, preparação e deploy do projeto.

---

## ⚙️ Como começar

### Pré-requisitos

- Docker e Docker Compose instalados
- Git
- Node.js (para testes e desenvolvimento local)

### Clonar o repositório

```bash
git clone https://github.com/sandrrei/biotronica.git
cd biotronica

---

### Subir containers Docker (backend + frontend + serviços)


cd docker
docker compose up -d


---

### Parar containers

docker compose down


### Rebuild completo

docker compose build --no-cache


### Executar testes


npm run test




📁 Estrutura do projeto

biotronica/
├── data/               # ficheiros de dados públicos (.txt)
├── docker/             # Dockerfiles e docker-compose
├── html/               # Frontend PHP + Archivarix CMS
├── scripts/            # Scripts utilitários (limpeza, deploy, etc.)
├── src/                # Backend NestJS (TypeScript)
├── test/               # Testes unitários e end-to-end
├── dist/               # Build compilado (ignorado pelo Git)
├── node_modules/       # Dependências (ignorado pelo Git)
├── .gitignore          # Arquivos a ignorar no Git
└── README.md           # Documentação principal

📡 Integração com programas externos
Atualmente o projeto suporta integração com:

qWELLNESS (em produção)

Futuramente planeado para:

miniVOLL

scriptIMPORTER

downloader

freePEMF

ionZAPPER

Essas integrações permitem acesso e gestão centralizada de imagens, tratamentos e dados relevantes ao bem-estar.


🤝 Contribuições
Contribuições são muito bem-vindas! Sinta-se à vontade para abrir issues, enviar pull requests e discutir melhorias.


📜 Licença
Este projeto está atualmente sem licença definida — use com responsabilidade e para fins educacionais.


📬 Contato
Para dúvidas, sugestões ou parcerias, contate via GitHub ou email (sandrrei@gmail.com).




