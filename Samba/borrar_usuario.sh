#!/bin/bash
# Neo Armada - Gestion de Usuarios (Borrar usuarios en Samba).

# Comprobar que se ejecuta con privilegios.
comprobar_root(){
    if (( $UID != 0 )); then
        echo "ERROR: Este Script debe ejecutarse con sudo o como root."
        exit 1
    fi
}

# Función para listar usuarios de Samba y sus grupos
listar_usuarios() {
    echo -e "\n=== Usuarios actuales en Samba y sus Grupos ==="
    echo "------------------------------------------------"
    # pdbedit lista los usuarios de samba. Extraemos solo el nombre.
    users=$(pdbedit -L | cut -d ":" -f 1)

    if [ -z "$users" ]; then
        echo "No hay usuarios registrados en Samba."
        return 1
    fi

    for user in $users; do
        # Obtenemos los grupos del usuario en el sistema
        grupos=$(groups "$user" | cut -d ":" -f 2)
        echo "Usuario: $user | Grupos:$grupos"
    done
    echo "------------------------------------------------"
    return 0
}

# Función para borrar usuario
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

# Función principal (Menú)
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
