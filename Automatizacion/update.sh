#!/bin/bash
# Neo Armada.

# Comprobar que se ejecuta con privilegios.
comprobar_root(){
    if (( $UID != 0 ));then 
        echo "ERROR: Este Script debe ejecutarse con sudo o como root."
        exit 1
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

    # Limpiar retornos de carro (CRLF a LF) y volcar directamente
    sed 's/\r$//' "$origen" >> "$destino" # Es más eficiente que un bucle while para archivos de configuración
    source /etc/profile.d/auto_neo.sh
}

# Funcion que ejecuta el Script. Actualiza los templates.
main(){
    local REPO_URL="https://github.com/Neoarmadam/Proyecto_ASIR" #Ruta de mi Github.
    local TARGET_DIR="/Auto_Neo" #Ruta de la carpeta de clonacion del GitHub.
    local DIR_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local ARCHIVO_ALIASTXT="$DIR_SCRIPT/alias.txt"
    local config_global="/etc/profile.d/auto_neo.sh"

    echo "--- Actualizando plantillas..."
    sudo rm -rf $TARGET_DIR
    sudo git clone $REPO_URL $TARGET_DIR
    sudo chmod +x -R $TARGET_DIR
    echo "[+]Repositorio actualizado."
    echo "--- Actualizando alias..."
    comprobar_alias "$ARCHIVO_ALIASTXT"
    hacer_backup "$config_global"
    aplicar_alias "$ARCHIVO_ALIASTXT" "$config_global"
    echo "[+]Alias actualizados."
}

main
