# 📘 README-dev.md — Notas de Desenvolvimento

Este ficheiro contém comandos úteis, notas e instruções internas para desenvolvimento do projeto **biotronica**.

---

## 📁 Estrutura do Projeto

```
biotronica/
├── data/               # ficheiros .txt de dados públicos
├── docker/             # Dockerfiles (PHP + Node)
├── html/               # Frontend com Archivarix CMS
├── scripts/            # Scripts utilitários internos
├── src/                # Backend NestJS (TypeScript)
├── test/               # Testes (Jest + Supertest)
├── dist/               # Build gerado (ignorado por git)
├── node_modules/       # Dependências (ignorado por git)
├── .gitignore          # Arquivos a ignorar no Git
└── docker-compose.yml  # Subida de serviços
```

---

## 🐳 Docker: Comandos principais

### Subir o projeto completo

```bash
cd docker
docker compose up -d
```

### Parar serviços

```bash
docker compose down
```

### Rebuild completo

```bash
docker compose build --no-cache
```

### Aceder ao backend ou PHP container

```bash
docker exec -it backend /bin/sh
# ou
docker exec -it php /bin/bash
```

---

## 🧹 Script interno de limpeza

Executa:

```bash
./scripts/limpar-e-preparar.sh
```

Ele faz:

* Atualiza `.gitignore`
* Remove ficheiros como:

  * dist/
  * node\_modules/
  * html/.content.\*
  * node-backend-\* pods montados
* Adiciona arquivos úteis e faz commit se necessário

---

## 💾 Backup do repositório

Para garantir backup no GitHub:

```bash
git status
# verifique alterações

git add .
git commit -m "mensagem de commit"
git push origin main
```

> ⚠️ Use `master` se for a branch usada inicialmente

---

## ⚙️ Testes

```bash
npm run test
```

---

## 📦 Instalar dependências (no host ou container)

```bash
npm install
```

---

## 📤 Fazer push manual para GitHub (branch main ou master)

```bash
git push origin main
# ou
git push origin master
```

---

## 🧪 Notas úteis

* Repositório Git está em: [https://github.com/sandrrei/biotronica](https://github.com/sandrrei/biotronica)
* Frontend usa PHP + Archivarix CMS
* Backend: NestJS + Redis + MongoDB
* Todos os dados públicos estão em `data/*.txt`

---

## 🔄 Reset em caso de erro no rebase

```bash
git rebase --abort
```

---

## 📜 Histórico

* README gerado automaticamente após limpeza
* Scripts facilitam versionamento limpo
* Excluímos arquivos temporários e pods montados

