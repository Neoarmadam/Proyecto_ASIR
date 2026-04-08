#!/bin/bash
# Neo Armada.

# Comprobar que se ejecuta con privilegios.
comprobar_root(){
    if (( $UID != 0 ));then 
        echo "Este Script se ejecuta con derechos de administrador."
        exit 1
    fi
}

# Función para mostrar el menú y capturar el grupo.
seleccionar_grupo() {
    echo "--- Selecciona el grupo para el nuevo usuario:"
    echo "(1) editores   (Ver, Crear, Editar)"
    echo "(2) streamers  (Ver, Crear, Editar, Eliminar)"
    echo "(3) admins     (Control Total)"
    read -p "Opción [1-3]: " OPCION

    case $OPCION in
        1) GRUPO="editores" ;;
        2) GRUPO="streamers" ;;
        3) GRUPO="admins" ;;
        *)
            echo "Error: Opción no válida."
            exit 1
            ;;
    esac
}

# Función para crear el usuario en Linux.
crear_usuario_linux() {
    read -p "--- Introduce el nombre del nuevo usuario: " USUARIO

    if id "$USUARIO" &>/dev/null; then
        echo "- Aviso: El usuario '$USUARIO' ya existe. Saltando creación..."
        echo "Recuerda que el usuario debe ser solo de Samba."
        exit 1
    else
        sudo useradd -m -s /sbin/nologin "$USUARIO" # Creamos usuario sin shell para mayor seguridad en Samba.
        echo "- Usuario Linux '$USUARIO' creado correctamente."
    fi
}

# Función para configurar Samba y permisos.
configurar_samba() {
    sudo usermod -aG "$GRUPO" "$USUARIO" # Asignar grupo al usuario creado anteriormente.
    echo "- Usuario '$USUARIO' añadido al grupo '$GRUPO'."

    # Contraseña de Samba.
    echo "--- Establece la contraseña de RED (Samba) para '$USUARIO':"
    sudo smbpasswd -a "$USUARIO"

    # Reinicio de servicio.
    sudo systemctl restart smb #Comprobar que funcione.
}

# Funcion que ejecuta el Script.
main() {
    echo "=== Gestor de Usuarios Samba ==="
    comprobar_root
    seleccionar_grupo
    crear_usuario_linux
    configurar_samba

    echo "--- El usuario '$USUARIO' ya tiene acceso como $GRUPO"
}

main