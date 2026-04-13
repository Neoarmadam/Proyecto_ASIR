## Index

* [comprobar_root](#comprobarroot)
* [instalar_samba](#instalarsamba)
* [crear_grupos](#creargrupos)
* [crear_carpetas](#crearcarpetas)
* [configurar_smb](#configurarsmb)
* [configurar_firewall](#configurarfirewall)
* [main](#main)

### comprobar_root

Comprueba si el script se ejecuta con privilegios de superusuario.

#### Exit codes

* **1**: Si el usuario no es root.

### instalar_samba

Instala los paquetes samba, samba-common y la utilidad acl mediante DNF.

### crear_grupos

Grupos creados: editores, streamers, admins.

### crear_carpetas

Configura SELinux (samba_share_t) y aplica ACLs para asegurar herencia de permisos rwx.

### configurar_smb

Define el recurso [Videos] con restricciones de acceso por grupo.

### configurar_firewall

Configura el Firewall de Fedora para permitir tráfico de Samba y habilita los servicios smb/nmb.

### main

Función principal que define la ruta base y orquesta la instalación completa.

