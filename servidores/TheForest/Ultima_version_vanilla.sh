#!/bin/bash
# Neo Armada.

# Preguntas al usuario
read -p "Nombre del contenedor: " nombre
read -p "Ruta local para datos (ej. /opt/mc_server): " carpeta

# Crear directorio si no existe
mkdir -p "$carpeta"

# Ejecución en Podman
echo "Desplegando servidor..."
podman run -d \
  --name "$nombre" \
  -v "$carpeta":/theforest:Z \
  -p 27015:27015/udp \
  -p 27016:27016/udp \
  -p 8766:8766/udp \
  --restart always \
  docker.io/jammsen/the-forest-dedicated-server:latest

echo "[+] Servidor $nombre listo."