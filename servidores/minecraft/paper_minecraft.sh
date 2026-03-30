#!/bin/bash

# Preguntas al usuario
read -p "Nombre del contenedor: " CONT_NAME
read -p "Puerto a mapear (ej. 25565): " PORT
read -p "Ruta local para datos (ej. /opt/mc_server): " VOL_PATH

# Crear directorio si no existe
mkdir -p "$VOL_PATH"

# Ejecución en Podman
echo "Desplegando servidor..."
podman run -d \
  --name "$CONT_NAME" \
  -p "0.0.0.0:$PORT":25565 \
  -v "$VOL_PATH":/data:Z \
  -e EULA=TRUE \
  docker.io/itzg/minecraft-server

echo "[+] Servidor $CONT_NAME listo en el puerto $PORT"