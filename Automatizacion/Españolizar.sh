#!/bin/bash
# Neo Armada.

# Comprobar que se ejecuta con privilegios.
comprobar_root(){
    if [[ $EUID -ne 0 ]]; then 
        echo "ERROR: Este Script debe ejecutarse con sudo o como root."
        exit 1
    fi
}

# Instalar dependencias en el servidor.
instalar_dependencias(){
    local REPO_URL="https://github.com/Neoarmadam/Proyecto_ASIR"
    local TARGET_DIR="/Auto_Neo"

    echo "- Se van a instalar dependencias elegidas por el gran desarrollador del Proyecto."
    sleep 1
    dnf install git cockpit-podman cockpit-storaged cockpit-files -y

    curl -s https://install.zerotier.com | sudo bash

    if [ ! -d "$TARGET_DIR" ]; then
        git clone "$REPO_URL" "$TARGET_DIR"
    else
        echo "- El directorio $TARGET_DIR ya existe, omitiendo clonación."
    fi
}

# Comprobar que el archivo alias esta.
comprobar_alias(){
    if [[ ! -f "$1" ]]; then
        echo "ERROR: No se encuentra el archivo '$1'."
        exit 1
    fi
}

# Crear Backup (Solo si el archivo ya existe).
hacer_backup() {
    local archivo="$1"
    if [[ -f "$archivo" ]]; then
        local nombre_bak="${archivo}.bak_$(date +%F_%H%M%S)"
        cp "$archivo" "$nombre_bak"
        echo "- Backup creado: $nombre_bak"
    fi
    : > "$archivo" 
    chmod 644 "$archivo"
    chown root:root "$archivo"
}

# Añadir los alias de forma limpia.
aplicar_alias() {
    local origen="$1"
    local destino="$2"

    echo "--- ESPAÑOLIZANDO el servidor globalmente..."
    
    # Limpiar retornos de carro (CRLF a LF) y volcar directamente
    sed 's/\r$//' "$origen" >> "$destino" # Es más eficiente que un bucle while para archivos de configuración
}

# Funcion que reinicia el servidor al acabar.
reiniciar_servidor() {
    echo "--- Reiniciando el servidor para aplicar cambios globales. Ahora es ESPAÑOL. ---"
    sleep 3
    sudo reboot
}

# Funcion que dibuja una bandera de España.
dibujar_bandera() {
    local ROJO='\033[0;31m'
    local AMARILLO='\033[1;33m'
    local NC='\033[0m'

    echo -e "${ROJO}#######################################${NC}"
    echo -e "${ROJO}#######################################${NC}"
    echo -e "${AMARILLO}#######################################${NC}"
    echo -e "${AMARILLO}##########  ESPAÑOLIZADO  #############${NC}"
    echo -e "${AMARILLO}#######################################${NC}"
    echo -e "${ROJO}#######################################${NC}"
    echo -e "${ROJO}#######################################${NC}"
    echo ""
}

# Funcion para dar avisos al usuario.
avisos(){
    local opcion 

    echo "--- Se está ejecutando el script: $0"
    sleep 1

    echo "- Se recomienda actualizar el sistema antes de continuar. Este Script no lo puede hacer, existe probabilidad de reiniciar Cockpit."
    read -p "Presiona [ENTER] para continuar o cualquier otra tecla para salir... " opcion

    if [[ -n "$opcion" ]]; then
        echo "Operación cancelada por el usuario."
        exit 1
    fi

    echo "- Estas seguro de continuar, no nos hacemos responsables de cualquier daño generado por la ejecucion del Script."
    read -p "Presiona [ENTER] para continuar o cualquier otra tecla para salir... " opcion

    if [[ -n "$opcion" ]]; then
        echo "- Operación cancelada por el usuario."
        exit 1
    fi

    echo "- Continuando..."
    sleep 1
}

# Funcion principal.
main() {
    local DIR_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local ARCHIVO_ALIASTXT="$DIR_SCRIPT/alias.txt"
    local config_global="/etc/profile.d/auto_neo.sh" #La idea es que los alias sean para todos los usuarios de Linux.

    comprobar_root
    avisos
    comprobar_alias "$ARCHIVO_ALIASTXT"
    instalar_dependencias
    clear
    dibujar_bandera
    hacer_backup "$config_global"
    aplicar_alias "$ARCHIVO_ALIASTXT" "$config_global"
    reiniciar_servidor
}

main
