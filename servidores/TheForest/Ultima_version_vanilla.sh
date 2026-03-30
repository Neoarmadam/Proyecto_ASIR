#!/bin/bash

# Preguntas al usuario
read -p "Nombre del contenedor: " CONT_NAME
read -p "Ruta local para datos (ej. /opt/mc_server): " VOL_PATH

# Crear directorio si no existe
mkdir -p "$VOL_PATH"

podman run -d \
  --name "$CONT_NAME" \
  -v "$VOL_PATH":/theforest:Z \
  -p 27015:27015/udp \
  -p 27016:27016/udp \
  -p 8766:8766/udp \
  --restart always \
  docker.io/jammsen/the-forest-dedicated-server:latest