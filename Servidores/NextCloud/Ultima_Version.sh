#!/bin/bash

# --- Colores ---
VERDE='\033[0;32m'
AZUL='\033[0;34m'
NC='\033[0m'

echo -e "${VERDE}--- Nextcloud en Pod con Red Interna Aislada ---${NC}"

# 1. Parámetros
read -p "Introduce el nombre base (ej. mi_nube): " BASE_NAME
read -p "Puerto para la APP WEB (ej. 8080): " WEB_PORT

# 2. Rutas
DIR_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
read -p "Ruta para datos [$DIR_SCRIPT/$BASE_NAME]: " RUTA_BASE
RUTA_BASE=${RUTA_BASE:-$DIR_SCRIPT/$BASE_NAME}

# Definición de nombres según tus reglas
POD_NAME="${BASE_NAME}_pod"
APP_NAME="${BASE_NAME}_app"
DB_NAME="${BASE_NAME}_db"
NET_NAME="${BASE_NAME}_red"

DIR_APP="$RUTA_BASE/${BASE_NAME}_app"
DIR_DB="$RUTA_BASE/${BASE_NAME}_db"

# 3. Limpieza total
echo -e "\n${AZUL}> Limpiando entorno anterior...${NC}"
podman pod rm -f "$POD_NAME" 2>/dev/null
podman network rm "$NET_NAME" 2>/dev/null
mkdir -p "$DIR_APP" "$DIR_DB"

# 4. Crear la Red
echo "> Creando red: $NET_NAME"
podman network create "$NET_NAME"

# 5. CREAR EL POD (Aquí se mapea el puerto de la APP)
# Al mapearlo aquí, el tráfico que llegue al puerto WEB_PORT irá al puerto 80 del POD
echo "> Creando Pod con el puerto mapeado para la App: $POD_NAME"
podman pod create \
    --name "$POD_NAME" \
    --network "$NET_NAME" \
    -p "$WEB_PORT":80

# 6. Lanzar la DB dentro del POD (Aislada por naturaleza del Pod)
# No exponemos puertos, queda interna en el stack del Pod
echo "> Añadiendo Base de Datos al Pod..."
podman run -d \
    --name "$DB_NAME" \
    --pod "$POD_NAME" \
    -v "$DIR_DB:/var/lib/mysql:Z" \
    -e MYSQL_ROOT_PASSWORD=pass_root \
    -e MYSQL_PASSWORD=pass_user \
    -e MYSQL_DATABASE=nextcloud \
    -e MYSQL_USER=nextcloud \
    mariadb:10.6 --transaction-isolation=READ-COMMITTED --binlog-format=ROW

# 7. Lanzar la APP dentro del POD
# La app escucha internamente en el 80, que ya está mapeado en el Pod
echo "> Añadiendo Aplicación al Pod..."
podman run -d \
    --name "$APP_NAME" \
    --pod "$POD_NAME" \
    -v "$DIR_APP:/var/www/html:Z" \
    -e MYSQL_HOST=127.0.0.1 \
    -e MYSQL_DATABASE=nextcloud \
    -e MYSQL_USER=nextcloud \
    -e MYSQL_PASSWORD=pass_user \
    nextcloud:latest

# 8. Finalización
LAN_IP=$(hostname -I | awk '{print $1}')
echo -e "\n${VERDE}¡Listo! Entorno funcionando en Pod.${NC}"
echo "-------------------------------------------------------"
echo "Acceso: http://$LAN_IP:$WEB_PORT"
echo "La DB es interna y solo accesible desde el Pod (127.0.0.1)"
echo "-------------------------------------------------------"
