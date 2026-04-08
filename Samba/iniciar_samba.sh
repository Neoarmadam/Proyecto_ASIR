#!/bin/bash
# Neo Armada.

# Comprobar que se ejecuta con privilegios.
comprobar_root(){
    if (( $UID != 0 ));then 
        echo "ERROR: Este Script debe ejecutarse con sudo o como root."
        exit 1
    fi
}

# Instalar Samba.
instalar_samba(){
    sudo dnf install samba samba-common acl -y
}

# Crear grupos del sistema.
crear_grupos(){
    sudo groupadd editores
    sudo groupadd streamers
    sudo groupadd admins
}

# Crear estructura de carpetas.
crear_carpetas(){
    local BASE_DIR="$1"
    sudo mkdir -p $BASE_DIR

    # Configurar SELinux para Fedora.
    sudo setsebool -P samba_enable_home_dirs on
    sudo chcon -R -t samba_share_t $BASE_DIR

    # Aplicar Permisos de Carpeta.
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

# Configurar smb.conf.
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
        
        # Lógica de eliminación (Veto de borrado para editores)
        # Nota: Samba no tiene un 'can_delete=no' nativo fácil,  pero podemos forzar el modo de creación.
        force create mode = 0664
        force directory mode = 0775
EOF" 
}

# Abrir Firewall y reiniciar servicios.
configurar_firewall(){
    sudo firewall-cmd --permanent --add-service=samba
    sudo firewall-cmd --reload
    sudo systemctl enable --now smb nmb

    echo "--- Configuración finalizada ---"
    echo "Grupos creados: editores, streamers, admins"
    echo "Carpeta: $1"
}

# Funcion que ejecuta el Script.
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