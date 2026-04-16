#!/bin/bash
# Neo Armada

# # @file Samba/iniciar_samba.sh
# @brief Script de instalación y aprovisionamiento inicial de un servidor Samba.
# @description Este script instala los paquetes necesarios, crea una estructura de grupos
# de trabajo (editores, streamers, admins), configura permisos avanzados mediante ACLs,
# ajusta políticas de SELinux y genera un archivo smb.conf optimizado para Fedora.

# @description Comprueba si el script se ejecuta con privilegios de superusuario.
# @exitcode 1 Si el usuario no es root.
comprobar_root(){
    if (( $UID != 0 ));then
        echo "ERROR: Este Script debe ejecutarse con sudo o como root."
        exit 1
    fi
}

# @description Instala los paquetes samba, samba-common y la utilidad acl mediante DNF.
instalar_samba(){
    sudo dnf install samba samba-common acl -y
}

# @description Crea los grupos de sistema necesarios para la lógica de permisos del servidor.
# @description Grupos creados: editores, streamers, admins.
crear_grupos(){
    sudo groupadd editores
    sudo groupadd streamers
    sudo groupadd admins
}

# @description Crea el directorio raíz para los compartidos y aplica seguridad a nivel de kernel y sistema de archivos.
# @description Configura SELinux (samba_share_t) y aplica ACLs para asegurar herencia de permisos rwx.
# @param $1 string Ruta absoluta del directorio base (ej. /srv/samba/Videos).
crear_carpetas(){
    local BASE_DIR="$1"
    sudo mkdir -p $BASE_DIR

    # Configurar SELinux para Fedora.
    sudo setsebool -P samba_enable_home_dirs on
    sudo chcon -R -t samba_share_t $BASE_DIR

    # Aplicar Permisos de Carpeta (Setgid activo).
    sudo chown root:admins $BASE_DIR
    sudo chmod 2775 $BASE_DIR

    # Usamos ACLs para asegurar que los nuevos archivos hereden permisos.
    sudo setfacl -R -m g:admins:rwx $BASE_DIR
    sudo setfacl -R -d -m g:admins:rwx $BASE_DIR
    sudo setfacl -R -m g:streamers:rwx $BASE_DIR
    sudo setfacl -R -d -m g:streamers:rwx $BASE_DIR
    sudo setfacl -R -m g:editores:r-x $BASE_DIR
    sudo setfacl -R -d -m g:editores:r-x $BASE_DIR
}

# @description Sobrescribe el archivo /etc/samba/smb.conf con una configuración predefinida.
# @description Define el recurso [Videos] con restricciones de acceso por grupo.
# @param $1 string Ruta del directorio compartido para la configuración de Samba.
configurar_smb(){
    sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
    sudo bash -c "cat <<EOF > /etc/samba/smb.conf
    [global]
        workgroup = WORKGROUP
        server string = Samba Video Server
        security = user
        map to guest = bad user

    [Videos]
        path = $1
        browsable = yes
        read only = no
        guest ok = no

        # Restricciones por grupo
        valid users = @editores, @streamers, @admins
        write list = @editores, @streamers, @admins

        # Lógica de creación
        force create mode = 0664
        force directory mode = 0775
EOF"
}

# @description Configura el Firewall de Fedora para permitir tráfico de Samba y habilita los servicios smb/nmb.
# @param $1 string Ruta de la carpeta configurada (para propósitos de log).
configurar_firewall(){
    sudo firewall-cmd --permanent --add-service=samba
    sudo firewall-cmd --reload
    sudo systemctl enable --now smb nmb

    echo "--- Configuración finalizada ---"
    echo "Grupos creados: editores, streamers, admins"
    echo "Carpeta: $1"
}

# @description Función principal que define la ruta base y orquesta la instalación completa.
main(){
    local BASE_DIR="/srv/samba/Videos"

    comprobar_root
    instalar_samba
    crear_grupos
    crear_carpetas "$BASE_DIR"
    configurar_smb "$BASE_DIR"
    configurar_firewall "$BASE_DIR"
}

main
