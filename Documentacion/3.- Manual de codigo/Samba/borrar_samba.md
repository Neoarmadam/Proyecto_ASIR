# Desinstalar_Samba.sh

Script para la eliminación completa de Samba, sus configuraciones, usuarios y grupos.

## Overview

Este script realiza una limpieza profunda de Samba en sistemas Fedora.
Elimina paquetes, servicios, reglas de firewall, archivos de configuración residuales
y los usuarios/grupos específicos creados para la gestión de red (editores, streamers, admins).

## Index

* [comprobar_root](#comprobarroot)
* [avisos](#avisos)
* [eliminar_samba](#eliminarsamba)
* [limpiar_configuraciones](#limpiarconfiguraciones)
* [eliminar_usuarios_y_grupos](#eliminarusuariosygrupos)
* [main](#main)

### comprobar_root

Comprueba si el script se ejecuta con privilegios de superusuario.

#### Exit codes

* **1**: Si el usuario no es root.

### avisos

Muestra avisos de seguridad y solicita confirmación doble al usuario.

#### Exit codes

* **1**: Si el usuario cancela la operación.

### eliminar_samba

Elimina los paquetes de Samba mediante DNF, deshabilita servicios y limpia el firewall.

### limpiar_configuraciones

Elimina físicamente los directorios de configuración, logs y caché de Samba.

### eliminar_usuarios_y_grupos

Posteriormente, elimina los grupos del sistema.

### main

Incluye una confirmación final opcional para borrar datos residuales y usuarios.

