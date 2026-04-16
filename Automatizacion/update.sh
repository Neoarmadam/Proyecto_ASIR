#!/bin/bash
# Neo Armada

# @file update.sh
# @brief Script para actualizar el repositorio de automatización de Neo y configurar alias.
# @description Este script clona un repositorio de GitHub, gestiona archivos de configuración
# en /etc/profile.d/ y aplica alias del sistema. Requiere privilegios de root.

# @description Comprueba si el usuario tiene privilegios de superusuario.
# @exitcode 1 Si el usuario no es root.
comprobar_root(){
    if (( $UID != 0 ));then
        echo "ERROR: Este Script debe ejecutarse con sudo o como root."
        exit 1
    fi
}

# @description Verifica la existencia de un archivo necesario para los alias.
# @param $1 string Ruta al archivo de alias.
# @exitcode 1 Si el archivo no existe.
comprobar_alias(){
    if [[ ! -f "$1" ]]; then
        echo "ERROR: No se encuentra el archivo '$1'."
        exit 1
    fi
}

# @description Crea un backup con marca de tiempo y vacía el archivo original.
# @param $1 string Ruta del archivo al que se le hará el backup.
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

# @description Añade el contenido de un archivo a otro, eliminando formatos de línea de Windows (CRLF).
# @param $1 string Archivo origen.
# @param $2 string Archivo destino.
aplicar_alias() {
    local origen="$1"
    local destino="$2"

    # Limpiar retornos de carro (CRLF a LF) y volcar directamente
    sed 's/\r$//' "$origen" >> "$destino"
}

# @description Informa al usuario y reinicia el sistema.
reiniciar_servidor() {
    echo "--- Reiniciando el servidor para aplicar las actualizaciones correctamente. ---"
    sleep 3
    sudo reboot
}

# @description Muestra avisos legales y de confirmación al usuario.
# @exitcode 1 Si el usuario cancela la operación con cualquier tecla que no sea ENTER.
avisos(){
    local opcion

    echo "--- Se está ejecutando el script: $0"
    sleep 1

    echo "- Este Script va a actualizar el repositorio de automatizacion de Neo."
    read -p "Presiona [ENTER] para continuar o cualquier otra tecla para salir... " opcion

    if [[ -n "$opcion" ]]; then
        echo "Operación cancelada por el usuario."
        exit 1
    fi

    echo "- Tambien se va a actualizar los alias del servidor."
    read -p "Presiona [ENTER] para continuar o cualquier otra tecla para salir... " opcion

    if [[ -n "$opcion" ]]; then
        echo "- Operación cancelada por el usuario."
        exit 1
    fi

    echo "- Continuando..."
    sleep 1
}

# @description Función principal que coordina la actualización del repo y los alias.
main(){
    local REPO_URL="https://github.com/Neoarmadam/Proyecto_ASIR"
    local TARGET_DIR="/Auto_Neo"
    local DIR_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local ARCHIVO_ALIASTXT="$DIR_SCRIPT/alias.txt"
    local config_global="/etc/profile.d/auto_neo.sh"

    avisos
    echo "--- Actualizando plantillas..."
    rm -rf $TARGET_DIR
    git clone $REPO_URL $TARGET_DIR
    chmod +x -R $TARGET_DIR
    echo "[+]Repositorio actualizado."
    echo "--- Actualizando alias..."
    comprobar_alias "$ARCHIVO_ALIASTXT"
    hacer_backup "$config_global"
    aplicar_alias "$ARCHIVO_ALIASTXT" "$config_global"
    echo "[+]Alias actualizados."
    reiniciar_servidor
}

main
