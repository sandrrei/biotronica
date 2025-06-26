#!/bin/sh

echo "⌛ A aguardar MongoDB em mongo:27017..."
until nc -z mongo 27017; do
  echo "❌ Mongo ainda não está disponível. Aguardando..."
  sleep 2
done
echo "✅ Mongo está pronto!"

echo "⌛ A aguardar Redis em redis-db:6379..."
until nc -z redis-db 6379; do
  echo "❌ Redis ainda não está disponível. Aguardando..."
  sleep 2
done
echo "✅ Redis está pronto!"

# Executa o comando passado (ex: npm run start:dev)
exec "$@"