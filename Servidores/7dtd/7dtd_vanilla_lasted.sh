#!/bin/bash
# Neo Armada

read -p "Nombre del contenedor (ej. 7dtd_server): " nombre
read -p "Ruta local para datos (ej. /opt/7dtd): " carpeta

# Crear directorio si no existe
mkdir -p "$carpeta"

echo "Desplegando servidor de 7 Days to Die..."

# Nota: 7DTD usa principalmente UDP.
# El puerto 26900 TCP es para el listado del servidor (Steam).
podman run -d \
  --name "$nombre" \
  -v "$carpeta":/home/sdtdserver/serverfiles:Z \
  -p 26900:26900/tcp \
  -p 26900-26903:26900-26903/udp \
  -e TZ=Europe/Madrid \
  --restart always \
  docker.io/vinanrra/7dtd-server:latest

echo "[+] Servidor $nombre listo."
echo "Recuerda editar el archivo serversettings.xml dentro de $carpeta para cambiar la contraseña."
