#!/bin/bash
# Neo Armada

# Función para mostrar el menú y capturar el grupo
seleccionar_grupo() {
    echo "------------------------------------------"
    echo "Selecciona el grupo para el nuevo usuario:"
    echo "1) editores   (Ver, Crear, Editar)"
    echo "2) streamers  (Ver, Crear, Editar, Eliminar)"
    echo "3) admins     (Control Total)"
    echo "------------------------------------------"
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

# Función para crear el usuario en Linux
crear_usuario_linux() {
    read -p "Introduce el nombre del nuevo usuario: " USUARIO

    if id "$USUARIO" &>/dev/null; then
        echo "Aviso: El usuario '$USUARIO' ya existe. Saltando creación..."
    else
        # Creamos usuario sin shell para mayor seguridad en Samba
        sudo useradd -m -s /sbin/nologin "$USUARIO"
        echo "Usuario Linux '$USUARIO' creado correctamente."
    fi
}

# Función para configurar Samba y permisos
configurar_samba() {
    # Asignar grupo
    sudo usermod -aG "$GRUPO" "$USUARIO"
    echo "Usuario '$USUARIO' añadido al grupo '$GRUPO'."

    # Contraseña de Samba
    echo "------------------------------------------"
    echo "Establece la contraseña de RED (Samba) para '$USUARIO':"
    sudo smbpasswd -a "$USUARIO"

    # Reinicio de servicio
    #sudo systemctl restart smbd #No funciona
}

# Funcion que ejecuta el Script.
main() {
    echo "=== Gestor de Usuarios Samba ==="
    
    crear_usuario_linux
    seleccionar_grupo
    configurar_samba

    echo "------------------------------------------"
    echo "¡Éxito! El usuario '$USUARIO' ya tiene acceso."
    echo "Grupo: $GRUPO | Recurso: //$(hostname -I | awk '{print $1}')/Videos"
    echo "------------------------------------------"
}

main