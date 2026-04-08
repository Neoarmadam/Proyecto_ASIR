#!/bin/bash
# Neo Armada.

# Preguntas al usuario.
read -p "Nombre del contenedor: " nombre
read -p "Puerto a mapear (ej. 25565): " puerto
read -p "Ruta local para datos (ej. /opt/mc_server): " carpeta

# Crear directorio si no existe.
mkdir -p "$carpeta"

# Ejecución en Podman.
echo "Desplegando servidor..."
podman run -d \
  --name "$nombre" \
  -p "0.0.0.0:$puerto":25565 \
  -v "$carpeta":/data:Z \
  -e EULA=TRUE \
  docker.io/itzg/minecraft-server

echo "[+] Servidor $nombre listo en el puerto $puerto"