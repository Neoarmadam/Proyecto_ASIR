#!/bin/bash
# Neo Armada

# @file Samba/añadir_usuario.sh
# @brief Script para la creación de usuarios Samba con grupos de acceso específicos.
# @description Este script permite crear usuarios en el sistema sin acceso a shell
# y los vincula a grupos predefinidos (editores, streamers, admins) para gestionar
# permisos en recursos compartidos de Samba.

# @description Comprueba si el script se ejecuta con privilegios de superusuario.
# @exitcode 1 Si el usuario no es root.
comprobar_root(){
    if (( $UID != 0 ));then
        echo "ERROR: Este Script debe ejecutarse con sudo o como root."
        exit 1
    fi
}

# @description Muestra un menú interactivo para seleccionar el nivel de acceso.
# @description Define la variable global GRUPO.
# @exitcode 1 Si la opción ingresada no está entre 1 y 3.
seleccionar_grupo() {
    echo "- Selecciona el grupo para el nuevo usuario:"
    echo "(1) editores   (Ver, Crear, Editar)"
    echo "(2) streamers  (Ver, Crear, Editar, Eliminar)"
    echo "(3) admins      (Control Total)"
    read -p "Opción [1-3]: " OPCION

    case $OPCION in
        1) GRUPO="editores" ;;
        2) GRUPO="streamers" ;;
        3) GRUPO="admins" ;;
        *)
            echo "ERROR: Opción no válida."
            exit 1
            ;;
    esac
}

# @description Solicita el nombre del usuario y lo crea en el sistema.
# @description El usuario se crea con /sbin/nologin por seguridad.
# @description Define la variable global USUARIO.
# @exitcode 1 Si el usuario ya existe en el sistema.
crear_usuario_linux() {
    read -p "- Introduce el nombre del nuevo usuario: " USUARIO

    if id "$USUARIO" &>/dev/null; then
        echo "Aviso: El usuario '$USUARIO' ya existe. Saltando creación..."
        echo "Recuerda que el usuario debe ser solo de Samba. Debes evitar usar usuarios del servidor Linux."
        exit 1
    else
        sudo useradd -m -s /sbin/nologin "$USUARIO"
        echo "Usuario Linux '$USUARIO' creado correctamente."
    fi
}

# @description Asigna el usuario al grupo elegido y configura su contraseña de Samba.
# @description Reinicia el servicio smb para aplicar los cambios.
configurar_samba() {
    sudo usermod -aG "$GRUPO" "$USUARIO"
    echo "Usuario '$USUARIO' añadido al grupo '$GRUPO'."

    # Contraseña de Samba.
    echo "- Establece la contraseña de RED (Samba) para '$USUARIO':"
    sudo smbpasswd -a "$USUARIO"

    # Reinicio de servicio.
    sudo systemctl restart smb
}

# @description Función principal. Coordina la creación y configuración del usuario Samba.
main() {
    echo "=== Gestor de Usuarios Samba ==="
    comprobar_root
    seleccionar_grupo
    crear_usuario_linux
    configurar_samba

    echo "--- El usuario '$USUARIO' ya tiene acceso como $GRUPO"
}

main
