#!/bin/bash
# neo Armada

# @file Samba/borrar_usuario.sh
# @brief Script interactivo para listar y eliminar usuarios de Samba y del sistema Linux.
# @description Proporciona un menú sencillo para visualizar qué usuarios tienen acceso a Samba,
# a qué grupos pertenecen y permite eliminarlos de la base de datos TDB de Samba y,
# opcionalmente, borrar su cuenta de sistema y directorio personal.

# @description Comprueba si el script se ejecuta con privilegios de superusuario.
# @exitcode 1 Si el usuario no es root.
comprobar_root(){
    if (( $UID != 0 )); then
        echo "ERROR: Este Script debe ejecutarse con sudo o como root."
        exit 1
    fi
}

# @description Lista todos los usuarios registrados en Samba extrayendo la información con pdbedit.
# @description Para cada usuario, muestra los grupos del sistema a los que está asociado.
# @stdout Tabla con la relación Usuario | Grupos.
# @exitcode 1 Si no se encuentran usuarios en la base de datos de Samba.
listar_usuarios() {
    echo -e "\n=== Usuarios actuales en Samba y sus Grupos ==="
    echo "------------------------------------------------"
    # pdbedit lista los usuarios de samba. Extraemos solo el nombre.
    local users=$(pdbedit -L | cut -d ":" -f 1)

    if [ -z "$users" ]; then
        echo "No hay usuarios registrados en Samba."
        return 1
    fi

    for user in $users; do
        # Obtenemos los grupos del usuario en el sistema
        local grupos=$(groups "$user" | cut -d ":" -f 2)
        echo "Usuario: $user | Grupos:$grupos"
    done
    echo "------------------------------------------------"
    return 0
}

# @description Interfaz para la eliminación de un usuario específico.
# @description Primero verifica la existencia del usuario en Samba, lo elimina con smbpasswd
# y pregunta al administrador si desea realizar un 'userdel -r' en el sistema Linux.
# @exitcode 0 Si la operación se cancela o finaliza correctamente.
borrar_usuario() {
    listar_usuarios
    if [ $? -eq 0 ]; then
        read -p "- Introduce el nombre del usuario que deseas ELIMINAR: " USUARIO_BORRAR

        if [ -z "$USUARIO_BORRAR" ]; then
            echo "Operación cancelada."
            exit 0
        fi

        # Verificar si existe en Samba
        if pdbedit -L | grep -q "^$USUARIO_BORRAR:"; then
            echo "Eliminando usuario '$USUARIO_BORRAR' de Samba..."
            smbpasswd -x "$USUARIO_BORRAR"

            # Opcional: Eliminar también del sistema Linux
            read -p "¿Deseas eliminar también al usuario '$USUARIO_BORRAR' del sistema Linux? (s/n): " CONFIRMAR
            if [[ "$CONFIRMAR" =~ ^[Ss]$ ]]; then
                userdel -r "$USUARIO_BORRAR"
                echo "Usuario '$USUARIO_BORRAR' eliminado del sistema."
            fi

            systemctl restart smb
            echo "Proceso finalizado."
        else
            echo "ERROR: El usuario '$USUARIO_BORRAR' no existe en Samba."
        fi
    fi
}

# @description Función principal que despliega el menú de navegación del script.
main() {
    comprobar_root
    echo "=== Gestor de Usuarios Samba ==="
    echo "1) Listar usuarios y grupos"
    echo "2) Eliminar un usuario"
    echo "3) Salir"
    read -p "Selecciona una opción: " MENU_OPC

    case $MENU_OPC in
        1) listar_usuarios ;;
        2) borrar_usuario ;;
        3) exit 0 ;;
        *) echo "Opción no válida." ;;
    esac
}

main
