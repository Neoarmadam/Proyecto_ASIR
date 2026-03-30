#!/bin/bash
# Neo Armada

# Instalar dependencias en el servidor.
instalar_dependencias(){
    local REPO_URL="https://github.com/Neoarmadam/Proyecto_ASIR"
    local TARGET_DIR="/Auto_Neo"

    #sudo dnf update -y

    echo "Se van a instalar dependencias elegidas por el gran administrador en el servidor."
    sleep 1
    sudo dnf install git cockpit-podman cockpit-storaged cockpit-files -y

    curl -s https://install.zerotier.com | sudo bash

    # Evitar error si la carpeta ya existe.
    if [ ! -d "$TARGET_DIR" ]; then
        sudo git clone $REPO_URL $TARGET_DIR
    fi
}

# Comprobar que se ejecuta con privilegios.
comprobar_root(){
    if (( $EUID != 0 )); then 
        echo "Este Script debe ejecutarse con sudo o como root."
        exit 1
    fi
}

# Comprobar que el archivo alias esta.
comprobar_alias(){
    if [[ ! -f "$1" ]]; then
        echo "Error: No se encuentra el archivo '$1', tienes que copiarlo o crearlo con el Script."
        exit 1
    fi
}

# Ahora apunta a una ruta global que SIEMPRE se carga.
obtener_shell() {
    echo "/etc/profile.d/auto_neo.sh"
}

# Crear Backup (Solo si el archivo ya existe).
hacer_backup() {
    local archivo="$1"
    if [[ -f "$archivo" ]]; then
        local nombre_bak="${archivo}.bak_$(date +%F_%H%M%S)"
        sudo cp "$archivo" "$nombre_bak"
        sudo rm "$archivo"
        echo "Backup creado: $nombre_bak"
    fi
    # Lo creamos vacío para que el script pueda escribir
    sudo touch "$archivo"
    sudo chmod 644 "$archivo"
}

# Añadir los alias de forma limpia.
aplicar_alias() {
    local origen="$1"
    local destino="$2"

    # Comando para limpiar el archivo de alias por si acaso viene de Windows.
    sed -i 's/\r$//' "$1"

    echo "ESPAÑOLIZANDO el servidor globalmente..."

    while IFS= read -r linea || [[ -n "$linea" ]]; do
        # Saltar líneas vacías o comentarios.
        if [[ -z "${linea// }" || "$linea" == \#* ]]; then
            continue
        fi

        # Evitar duplicados.
        if grep -qF "$linea" "$destino"; then
            echo "  [-] Omitido (ya existe): $linea"
        else
            echo "$linea" >> "$destino"
            echo "  [+] Añadido: $linea"
        fi
    done < "$origen"
}

# Funcion que reinicia el servidor al acabar.
reiniciar_servidor() {
    echo "---"
    echo "Reinicio el servidor para aplicar cambios globales. Ahora es ESPAÑOL."
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

#Funcion para dar avisos al usuario.
avisos(){
    local opcion 

    echo "Se está ejecutando el script: $0"
    sleep 1

    echo "Se recomienda actualizar el sistema antes de continuar. Este Script no lo puede hacer, existe probabilidad de reiniciar Cockpit."
    read -p "Presiona [ENTER] para continuar o cualquier otra tecla para salir... " opcion

    if [[ -n "$opcion" ]]; then
        echo "Operación cancelada por el usuario."
        exit 1
    fi

    echo "Estas seguro de continuar, no nos hacemos responsables de cualquier daño generado por la ejecucion del Script."
    read -p "Presiona [ENTER] para continuar o cualquier otra tecla para salir... " opcion

    if [[ -n "$opcion" ]]; then
        echo "Operación cancelada por el usuario."
        exit 1
    fi

    echo "Continuando..."
    sleep 1
}

# Funcion principal.
main() {
    local ARCHIVO_ALIASTXT="alias.txt"
    local config_global=$(obtener_shell)

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