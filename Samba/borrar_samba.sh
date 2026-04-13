#!/bin/bash

# @file Desinstalar_Samba.sh
# @brief Script para la eliminación completa de Samba, sus configuraciones, usuarios y grupos.
# @description Este script realiza una limpieza profunda de Samba en sistemas Fedora.
# Elimina paquetes, servicios, reglas de firewall, archivos de configuración residuales
# y los usuarios/grupos específicos creados para la gestión de red (editores, streamers, admins).

# @description Comprueba si el script se ejecuta con privilegios de superusuario.
# @exitcode 1 Si el usuario no es root.
comprobar_root(){
    if (( $UID != 0 ));then
        echo "ERROR: Este Script debe ejecutarse con sudo o como root."
        exit 1
    fi
}

# @description Muestra avisos de seguridad y solicita confirmación doble al usuario.
# @exitcode 1 Si el usuario cancela la operación.
avisos(){
    local opcion

    echo "--- Se está ejecutando el script: $0"
    sleep 1

    echo "- Este Script va a eliminar Samba del sistema(El programa de las carpetas compartidas)"
    read -p "Presiona [ENTER] para continuar o cualquier otra tecla para salir... " opcion

    if [[ -n "$opcion" ]]; then
        echo "Operación cancelada por el usuario."
        exit 1
    fi

    echo "- Estas seguro de continuar, se va a borrar Samba de su sistema."
    read -p "Presiona [ENTER] para continuar o cualquier otra tecla para salir... " opcion

    if [[ -n "$opcion" ]]; then
        echo "Operación cancelada por el usuario."
        exit 1
    fi

    echo "Continuando..."
    sleep 1
}

# @description Elimina los paquetes de Samba mediante DNF, deshabilita servicios y limpia el firewall.
eliminar_samba() {
    echo "---Eliminando paquetes de Samba---"
    sleep 3
    dnf remove -y samba samba-common
    dnf autoremove -y
    sudo systemctl disable --now smb nmb > /dev/null 2>&1
    sudo firewall-cmd --permanent --remove-service=samba
    sudo firewall-cmd --reload
}

# @description Elimina físicamente los directorios de configuración, logs y caché de Samba.
limpiar_configuraciones() {
    echo "--- Eliminando archivos de configuración y directorios de datos ---"
    sleep 3
    rm -rf /etc/samba/
    rm -rf /var/lib/samba/
    rm -rf /var/log/samba/
    rm -rf /var/cache/samba/
    echo "Configuraciones eliminadas."
}

# @description Identifica y elimina a los usuarios pertenecientes a los grupos editores, streamers y admins.
# @description Posteriormente, elimina los grupos del sistema.
eliminar_usuarios_y_grupos() {
    local grupos=("editores" "streamers" "admins")

    echo "--- Procesando limpieza de usuarios y grupos ---"
    sleep 3

    for grupo in "${grupos[@]}"; do
        if getent group "$grupo" > /dev/null; then
            local miembros=$(getent group "$grupo" | cut -d: -f4 | tr ',' ' ')

            for usuario in $miembros; do
                echo "Eliminando usuario: $usuario"
                userdel -r "$usuario" 2>/dev/null || echo "No se pudo eliminar al usuario $usuario (puede que no exista o esté en uso)."
            done

            echo "Eliminando grupo: $grupo"
            groupdel "$grupo"
        else
            echo "El grupo $grupo no existe, saltando..."
        fi
    done
}

# @description Función principal que orquestra la desinstalación.
# @description Incluye una confirmación final opcional para borrar datos residuales y usuarios.
main(){
    comprobar_root
    local opcion

    echo "=== Script de Desinstalación de Samba para Fedora ==="
    avisos
    eliminar_samba

    echo "--- Se ha eliminado Samba del sistema."
    echo "- ¿Quieres eliminar los archivos de configuracion y usuarios que tenia Samba?"
    read -p "Presiona [ENTER] para continuar o cualquier otra tecla para salir... " opcion

    if [[ -n "$opcion" ]]; then
        echo "No se borraran los restos de Samba."
        exit 1
    else
        echo "Se va a proceder a eliminar los restos de Samba."
        limpiar_configuraciones
        eliminar_usuarios_y_grupos
    fi

    echo "Desinstalacion completada. Adios."

}

main
