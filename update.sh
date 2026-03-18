#!/bin/bash
# Neo Armada.

#Comprobar que se ejecuta con privilegios
comprobar_root(){
    if (( $UID != 0 ));then 
        echo "Este Script se ejecuta con derechos de administrador."
        exit 1
    fi
}

#Funcion que ejecuta el Script. Actualiza los templates.
main(){
    local REPO_URL="https://github.com/Neoarmadam/Proyecto_ASIR" #Ruta de mi Github.
    local TARGET_DIR="/Templates" #Ruta de la carpeta de Plantillas.

    echo "Actualizando plantillas..."
    sudo rm -rf $TARGET_DIR
    sudo git clone $REPO_URL $TARGET_DIR
    sudo chmod +x -R $TARGET_DIR
    echo "[+]Repositorio actualizado."
}

main
